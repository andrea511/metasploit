require 'spec_helper'

RSpec.describe Apps::Domino::Node, :ui do

  subject(:node) { FactoryBot.create(:apps_domino_node) }

  it { is_expected.to be_valid }

  context 'database' do
    context 'columns' do
      it_should_behave_like 'timestamp database columns'
      it { is_expected.to have_db_column(:run_id).of_type(:integer).with_options(null: false) }
      it { is_expected.to have_db_column(:host_id).of_type(:integer).with_options(null: false) }
    end

    context 'indices' do
      it { is_expected.to have_db_index([:host_id, :run_id]).unique(true) }
      it { is_expected.to have_db_index(:run_id).unique(false) }
      it { is_expected.to have_db_index(:host_id).unique(false) }
    end
  end

  context 'validations' do
    context 'host' do
      it { is_expected.to validate_presence_of :host }
      it { is_expected.to validate_uniqueness_of(:host_id).scoped_to(:run_id) }

      context 'consistent workspaces' do

        let(:other_workspace) { FactoryBot.create(:mdm_workspace) }

        before do
          node.host.workspace = other_workspace
          node.host.save!
        end

        it 'is not valid' do
          expect(node).not_to be_valid
        end

        it 'adds an error message to :host' do
          node.valid?
          expect(node.errors[:host]).to be_present
        end

      end
    end

    context 'run' do
      it { is_expected.to validate_presence_of :run }

      context 'attached_to_domino_metamodule' do
        context 'when the run has a symbol of "ABC"' do
          before do
            node.run.app = FactoryBot.create(:app, symbol: 'ABC')
            node.run.save!
          end

          it 'is not valid' do
            expect(node).not_to be_valid
          end

          it 'adds an error message to :run' do
            node.valid?
            expect(node.errors[:run]).to be_present
          end

        end
      end
    end
  end

  describe 'associations' do

    describe '#run' do
      it 'is an Apps::AppRun instance' do
        expect(node.run).to be_an(Apps::AppRun)
      end

      it 'belongs to an App with the symbol "domino"' do
        expect(node.run.app.symbol).to eq('domino')
      end
    end

    describe '#host' do
      it 'is an Mdm::Host instance' do
        expect(node.host).to be_an(Mdm::Host)
      end

      it 'is a valid Mdm::Host' do
        expect(node.host).to be_valid
      end

      it 'belongs to a valid workspace' do
        expect(node.host.workspace).to be_valid
      end

      it 'is in the same workspace as the run' do
        expect(node.host.workspace.id).to eq(node.run.workspace.id)
      end
    end

    describe '#edges' do
      it 'returns an empty Array' do
        expect(node.edges).to match_array([])
      end

      context 'when an Edge is created with this Node as its source' do
        let(:edge) { FactoryBot.create(:apps_domino_edge) }

        it 'returns an array containing that Edge' do
          expect(edge.source_node.edges).to match_array([edge])
        end
      end
    end

    describe '#captured_creds' do
      it 'returns an empty Array' do
        expect(node.captured_creds).to match_array([])
      end

      describe 'after adding a Core to the join table' do
        let(:core) { FactoryBot.create(:metasploit_credential_core_manual) }

        before do
          core.workspace_id = node.run.workspace_id
          core.save!
          node.captured_creds << core
          node.save!
        end

        it 'returns an Array containing that Core' do
          expect(node.captured_creds(true)).to match_array([core])
        end
      end
    end

    describe '#captured_creds_count' do
      it 'is 0 initially' do
        expect(node.captured_creds_count).to eq(0)
      end
    end

  end

  describe 'callbacks' do

    describe 'dependent: destroy' do

      context 'after destroying the parent AppRun' do
        before do
          node.run.destroy
        end

        it 'is destroyed' do
          expect(Apps::Domino::Node.exists? node).to be false
        end
      end

      context 'after destroying a Node with associated Edges' do
        let(:edge) { FactoryBot.create(:apps_domino_edge) }
        subject(:node) { edge.source_node }

        before do
          node.destroy
        end

        it 'destroys any associated source Edges' do
          expect(node.edges.any? { |e| e.persisted? }).to be false
        end

        it 'destroys the source Edge' do
          expect(node.source_edge).to be_nil
        end
      end

    end

  end

end
