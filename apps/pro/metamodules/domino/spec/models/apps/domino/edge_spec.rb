require 'spec_helper'

RSpec.describe Apps::Domino::Edge, :ui do

  subject(:edge) { FactoryBot.create(:apps_domino_edge) }

  it { is_expected.to be_valid }

  context 'database' do
    context 'columns' do
      it_should_behave_like 'timestamp database columns'
      it { is_expected.to have_db_column(:dest_node_id).of_type(:integer).with_options(null: false) }
      it { is_expected.to have_db_column(:login_id).of_type(:integer).with_options(null: false) }
      it { is_expected.to have_db_column(:run_id).of_type(:integer).with_options(null: false) }
      it { is_expected.to have_db_column(:source_node_id).of_type(:integer).with_options(null: false) }
    end

    context 'indices' do
      it { is_expected.to have_db_index([:dest_node_id, :run_id]).unique(true) }
      it { is_expected.to have_db_index([:login_id, :run_id]).unique(true) }
      it { is_expected.to have_db_index(:run_id).unique(false) }
    end
  end

  context 'validations' do
    context 'login' do
      it { is_expected.to validate_presence_of :login }
      it { is_expected.to validate_uniqueness_of(:login_id).scoped_to(:run_id) }
      it { is_expected.to validate_uniqueness_of(:dest_node_id).scoped_to(:run_id) }

      context 'consistent_workspaces' do

        let(:other_workspace) { FactoryBot.create(:mdm_workspace) }

        context 'when the login.core is in a separate workspace' do

          before do
            edge.login.core.workspace = other_workspace
            edge.login.core.save!
          end

          it 'is not valid' do
            expect(edge).not_to be_valid
          end

          it 'adds an error message to :login' do
            edge.valid?
            expect(edge.errors[:login]).to be_present
          end

        end

        context 'when the login.service.host is in a separate workspace' do

          before do
            edge.login.service.host.workspace = other_workspace
            edge.login.service.host.save!
          end

          it 'is not valid' do
            expect(edge).not_to be_valid
          end

          it 'adds an error message to :login' do
            edge.valid?
            expect(edge.errors[:login]).to be_present
          end

        end

      end
    end

    context 'run' do
      it { is_expected.to validate_presence_of :run }

      context 'attached_to_domino_metamodule' do
        context 'when the run has a symbol of "ABC"' do
          before do
            edge.run.app = FactoryBot.create(:app, symbol: 'ABC')
            edge.run.save!
          end

          it 'is not valid' do
            expect(edge).not_to be_valid
          end

          it 'adds an error message to :run' do
            edge.valid?
            expect(edge.errors[:run]).to be_present
          end

        end
      end

      context 'consistent_run_ids' do
        let(:other_run) { FactoryBot.create(:app_run) }

        before do
          other_run.workspace_id = edge.run.workspace_id
          other_run.save!
        end

        context 'when the dest_node and source_node have different run_ids than source_node' do
          before do
            edge.dest_node.run = other_run
            edge.dest_node.run.save!
            edge.source_node.run = other_run
            edge.source_node.run.save!
          end

          it 'is not valid' do
            expect(edge).not_to be_valid
          end

          it 'adds an error message to :dest_node' do
            edge.valid?
            expect(edge.errors[:dest_node]).to be_present
          end

          it 'adds an error message to :source_node' do
            edge.valid?
            expect(edge.errors[:source_node]).to be_present
          end
        end

        context 'when the dest_node has a different run_id than the Edge' do
          before do
            edge.dest_node.run = other_run
            edge.dest_node.run.save!
          end

          it 'is not valid' do
            expect(edge).not_to be_valid
          end

          it 'adds an error message to :dest_node' do
            edge.valid?
            expect(edge.errors[:dest_node]).to be_present
          end
        end

        context 'when the source_node has a different run_id than the Edge' do
          before do
            edge.source_node.run = other_run
            edge.source_node.run.save!
          end

          it 'is not valid' do
            expect(edge).not_to be_valid
          end

          it 'adds an error message to :source_node' do
            edge.valid?
            expect(edge.errors[:source_node]).to be_present
          end
        end
      end

      context 'source_does_not_equal_dest' do
        context 'when the source node equals the dest node' do

          before do
            edge.source_node_id = edge.dest_node_id
          end

          it 'is not valid' do
            expect(edge).not_to be_valid
          end

          it 'adds an error message to :dest_node' do
            edge.valid?
            expect(edge.errors[:dest_node]).to be_present
          end

        end
      end
    end
  end

  describe 'associations' do

    describe '#run' do
      it 'is an Apps::AppRun instance' do
        expect(edge.run).to be_an(Apps::AppRun)
      end

      it 'belongs to an App with the symbol "domino"' do
        expect(edge.run.app.symbol).to eq('domino')
      end
    end

    describe '#login' do
      it 'is a Metasploit::Credential::Login instance' do
        expect(edge.login).to be_an(Metasploit::Credential::Login)
      end

      it 'is a valid Mdm::Host' do
        expect(edge.login).to be_valid
      end

      it 'belongs to a core in a valid workspace' do
        expect(edge.login.core.workspace).to be_valid
      end

      it 'belongs to a core in the same workspace as the run' do
        expect(edge.login.core.workspace.id).to eq(edge.run.workspace.id)
      end
    end

    describe '#dest_node' do
      it 'is a Apps::Domino::Node instance' do
        expect(edge.dest_node).to be_an(Apps::Domino::Node)
      end

      it 'is a valid Apps::Domino::Node' do
        expect(edge.dest_node).to be_valid
      end
    end

    describe '#source_node' do
      it 'is a Apps::Domino::Node instance' do
        expect(edge.source_node).to be_an(Apps::Domino::Node)
      end

      it 'is a valid Apps::Domino::Node' do
        expect(edge.source_node).to be_valid
      end
    end

  end

  describe 'callbacks' do

    describe 'dependent: :destroy' do

      context 'after destroying the parent AppRun' do
        before do
          edge.run.destroy
        end

        it 'is destroyed' do
          expect(Apps::Domino::Edge.exists? edge).to be false
        end
      end

    end

  end

end
