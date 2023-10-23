# This Projection namespace is used to group all join models that map between different {Web::VulnCategory::Model}
# classes under {Web::VulnCategory}.
#
# Classes under this namespace should follow the normal Rails join model convention of having the two model's names
# listed in alphabetical order, so the join model for {Web::VulnCategory::Metasploit} and {Web::VulnCategory::OWASP} has
# 'Metasploit' first and 'OWASP' second, yielding the join model name {Web::VulnCategory::Projection::MetasploitOWASP}.
module Web::VulnCategory::Projection

end