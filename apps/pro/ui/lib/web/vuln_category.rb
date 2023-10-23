# Mdm::WebVuln#category is deprecated in Pro.  Instead, each Mdm::WebVuln references a category_id, which points to a
# {Web::VulnCategory::Metasploit}.  This {Web::VulnCategory::Metasploit} can be mapped to other categorization schemes,
# such as {Web::VulnCategory::OWASP OWASP Top Ten}.  Each categorization scheme should be an ApplicationRecord subclass
# under the Web::VulnCategory module.  Each {Web::VulnCategory} class should have name and summary columns, where name
# is a short, compact string and summary is a normal English phrase with any abbreviations from name spelled out,
# similar to how name and summary work for RPMs.  For mapping between categorization schemes there should be a minimum
# of a join table for mapping from {Web::VulnCategory::Metasploit} and the other categorization model, but additional
# join tables to map between non-Metasploit categorization schemes are allowed.
#
# To handle validation of classes in this namespace, include {Web::VulnCategory::Model} and to spec that the interface
# is followed, used the 'Web::VulnCategory::Model' shared example.
#
# @see Web::VulnCategory::Model
module Web::VulnCategory

end
