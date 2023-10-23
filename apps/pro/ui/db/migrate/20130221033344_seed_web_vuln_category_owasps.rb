# Seeds {Web::VulnCategory::OWASP} where {Web::VulnCategory::OWASP#target} is {TARGET 'Application'} and
# {web::VulnCategory::OWASP#version} is {VERSION '2010'}.
class SeedWebVulnCategoryOwasps < ActiveRecord::Migration[4.2]
 def change
     [
       {
         :detectability => 'average',
         :exploitability => 'easy',
         :impact => 'severe',
         :prevalence => 'common',
         :summary => 'Injection'
       },
       {
         :detectability => 'easy',
         :exploitability => 'average',
         :impact => 'moderate',
         :prevalence => 'very widespread',
         :summary => 'Cross-Site Scripting (XSS)'
       },
       {
         :detectability => 'average',
         :exploitability => 'average',
         :impact => 'severe',
         :prevalence => 'common',
         :summary => 'Broken Authentication and Session Management'
       },
       {
         :detectability => 'easy',
         :exploitability => 'easy',
         :impact => 'moderate',
         :prevalence => 'common',
         :summary => 'Insecure Direct Object References'
       },
       {
         :detectability => 'easy',
         :exploitability => 'average',
         :impact => 'moderate',
         :prevalence => 'widespread',
         :summary => 'Cross-Site Request Forgery (CSRF)'
       },
       {
         :detectability => 'easy',
         :exploitability => 'easy',
         :impact => 'moderate',
         :prevalence => 'common',
         :summary => 'Security Misconfiguration'
       },
       {
         :detectability => 'difficult',
         :exploitability => 'difficult',
         :impact => 'severe',
         :prevalence => 'uncommon',
         :summary => 'Insecure Cryptographic Storage'
       },
       {
         :detectability => 'average',
         :exploitability => 'easy',
         :impact => 'moderate',
         :prevalence => 'uncommon',
         :summary => 'Failure to Restrict URL Access'
       },
       {
         :detectability => 'easy',
         :exploitability => 'difficult',
         :impact => 'moderate',
         :prevalence => 'common',
         :summary => 'Insufficient Transport Layer Protection'
       },
       {
         :detectability => 'easy',
         :exploitability => 'average',
         :impact => 'moderate',
         :prevalence => 'uncommon',
         :summary => 'Unvalidated Redirect and Forwards'
       }
     ].each_with_index.map do |attrs, i|
         attrs[:target]  = 'Application'
         attrs[:version] = '2010'
         attrs[:rank]    = i + 1
         attrs
     end.each { |attrs| Web::VulnCategory::OWASP.create! attrs }
 end

end
