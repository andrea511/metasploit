# Seeds {Web::VulnCategory::OWASP} where {Web::VulnCategory::OWASP#target} is {TARGET 'Application'} and
# {web::VulnCategory::OWASP#version} is {VERSION '2013rc1'}.
class SeedWebVulnCategoryOwasps2013 < ActiveRecord::Migration[4.2]
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
            :detectability => 'average',
            :exploitability => 'average',
            :impact => 'severe',
            :prevalence => 'common',
            :summary => 'Broken Authentication and Session Management'
          },
          {
            :detectability => 'easy',
            :exploitability => 'average',
            :impact => 'moderate',
            :prevalence => 'very widespread',
            :summary => 'Cross-Site Scripting (XSS)'
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
            :exploitability => 'easy',
            :impact => 'moderate',
            :prevalence => 'common',
            :summary => 'Security Misconfiguration'
          },
          {
            :detectability => 'average',
            :exploitability => 'difficult',
            :impact => 'severe',
            :prevalence => 'uncommon',
            :summary => 'Sensitive Data Exposure'
          },
          {
            :detectability => 'average',
            :exploitability => 'easy',
            :impact => 'moderate',
            :prevalence => 'common',
            :summary => 'Missing Function Level Access Control'
          },
          {
            :detectability => 'easy',
            :exploitability => 'average',
            :impact => 'moderate',
            :prevalence => 'widespread',
            :summary => 'Cross-Site Request Forgery (CSRF)'
          },
          {
            :detectability => 'difficult',
            :exploitability => 'average',
            :impact => 'moderate',
            :prevalence => 'widespread',
            :summary => 'Using Components with Known Vulnerabilities'
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
            attrs[:version] = '2013rc1'
            attrs[:rank]    = i + 1
            attrs
        end.each { |attrs| Web::VulnCategory::OWASP.create! attrs }
    end

end
