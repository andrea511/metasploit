require 'securerandom'
require 'yaml'

# creates secrets_data hash and writes it to secrets.yml and updates Rails.application.secrets with new secret
def create_write_secret_data(secret_key_base, yaml_file)
  secret_token = { 'secret_key_base' => secret_key_base }
  secrets_data = {}
  secrets_data['development'] = secret_token
  secrets_data['test']        = secret_token
  secrets_data['production']  = secret_token
  Rails.application.secrets[:secret_key_base] = secret_key_base
  ::File.open(yaml_file, 'w') { |f| f.write(secrets_data.to_yaml)}
end
def clean_blacklisted_keys(yaml_file)
  # if the keyfile is among the ones we accidentally hardcoded, overwrite it with a new one
  blacklisted_secrets = ["d25e9ad8c9a1558a6864bc38b1c79eafef479ccee5ad0b4b2ff6a917cd8db4c6b80d1bf1ea960f8ef922ddfebd4525fcff253a18dd78a18275311d45770e5c9103fc7b639ecbd13e9c2dbba3da5c20ef2b5cbea0308acfc29239a135724ddc902ccc6a378b696600a1661ed92666ead9cdbf1b684486f5c5e6b9b13226982dd7",
                         "99988ff528cc0e9aa0cc52dc97fe1dd1fcbedb6df6ca71f6f5553994e6294d213fcf533a115da859ca16e9190c53ddd5962ddd171c2e31a168fb8a8f3ef000f1a64b59a4ea3c5ec9961a0db0945cae90a70fd64eb7fb500662fc9e7569c90b20998adeca450362e5ca80d0045b6ae1d54caf4b8e6d89cc4ebef3fd4928625bfc",
                         "446db15aeb1b4394575e093e43fae0fc8c4e81d314696ac42599e53a70a5ebe9c234e6fa15540e1fc3ae4e99ad64531ab10c5a4deca10c20ba6ce2ae77f70e7975918fbaaea56ed701213341be929091a570404774fd65a0c68b2e63f456a0140ac919c6ec291a766058f063beeb50cedd666b178bce5a9b7e2f3984e37e8fde",
                         "61c64764ca3e28772bddd3b4a666d5a5611a50ceb07e3bd5847926b0423987218cfc81468c84a7737c23c27562cb9bf40bc1519db110bf669987c7bb7fd4e1850f601c2bf170f4b75afabf86d40c428e4d103b2fe6952835521f40b23dbd9c3cac55b543aef2fb222441b3ae29c3abbd59433504198753df0e70dd3927f7105a",
                         "23bbd1fdebdc5a27ed2cb2eea6779fdd6b7a1fa5373f5eeb27450765f22d3f744ad76bd7fbf59ed687a1aba481204045259b70b264f4731d124828779c99d47554c0133a537652eba268b231c900727b6602d8e5c6a73fe230a8e286e975f1765c574431171bc2af0c0890988cc11cb4e93d363c5edc15d5a15ec568168daf32",
                         "18edd3c0c08da473b0c94f114de417b3cd41dace1dacd67616b864cbe60b6628e8a030e1981cef3eb4b57b0498ad6fb22c24369edc852c5335e27670220ea38f1eecf5c7bb3217472c8df3213bc314af30be33cd6f3944ba524c16cafb19489a95d969ada268df37761c0a2b68c0eeafb1355a58a9a6a89c9296bfd606a79615",
                         "b4bc1fa288894518088bf70c825e5ce6d5b16bbf20020018272383e09e5677757c6f1cc12eb39421eaf57f81822a434af10971b5762ae64cb1119054078b7201fa6c5e7aacdc00d5837a50b20a049bd502fcf7ed86b360d7c71942b983a547dde26a170bec3f11f42bee6a494dc2c11ae7dbd6d17927349cdcb81f0e9f17d22c"]
  if File.exist?(yaml_file)
    current_secret = File.read(yaml_file)
    blacklisted_secrets.each do |blacklisted|
      if current_secret.include? blacklisted
        create_write_secret_data(::SecureRandom.hex(128), yaml_file)
        break
      end
    end
  end
end

#check for the old secret key  file
token_file = ::File.expand_path(::File.join(::File.dirname(__FILE__), "..", "..", "tmp", "secret_key_base.txt"))
yaml_file = ::File.expand_path(::File.join(::File.dirname(__FILE__), "..", "secrets.yml"))

clean_blacklisted_keys(yaml_file)
if File.exist?(token_file)
  create_write_secret_data(File.read(token_file), yaml_file)
elsif !File.exist?(yaml_file) || YAML.load_file(yaml_file)["production"].nil? || YAML.load_file(yaml_file)["production"]["secret_key_base"].nil?
  create_write_secret_data(::SecureRandom.hex(128), yaml_file)
else
  Rails.application.secrets[:secret_key_base] = YAML.load_file(yaml_file)["production"]["secret_key_base"] || YAML.load_file(yaml_file)["development"]["secret_key_base"]
end
