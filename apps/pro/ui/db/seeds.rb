require 'csv'

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# It needs to be safe to run `rake db:seed` multiple times without creating duplicate records or erroring (i.e. it needs
# to be [idempotent](http://en.wikipedia.org/wiki/Idempotent#Computer_science_meaning)), so it is best to use
# `first_or_create!` on a scope that uniquely identifies each seed.
#
# This file is not absolutely DRY as listing all attributes explicitly makes it easier to add new seeds without
# restructuring the whole file as was needed in the past when adding a new version for {Web::VulnCategory::OWASP}.
#
# NOTES:
#   * Seeds are not run in installed environments.  You need a database migration to run seeds in installed
#     environments.
#   * If you see a new table, please add the table to the list of preserved tables in
#     features/support/test_config.rb.  This prevents these tables from being truncated before each
#     cucumber scenario.

# Array of Web::VulnCategory::Metasploit attribute Hashes.  :name will be used to map the `first_or_create!` seed
# into metasploit_by_name
metasploit_attributes = [
    {
        :name => 'CMDi',
        :summary => 'Command Injection'
    },
    {
        :name => 'CSRF',
        :summary => 'Cross-Site Request Forgery (CSRF)'
    },
    {
        :name => 'Direct-Object-Reference',
        :summary => 'Direct Object Reference'
    },
    {
        :name => 'LFI',
        :summary => 'Local File Inclusion'
    },
    {
        :name => 'Publicly-Writable-Directory',
        :summary => 'Publicly Writable Directory'
    },
    {
        :name => 'RFI',
        :summary => 'Remote File Inclusion'
    },
    {
        :name => 'SQLi',
        :summary => 'SQL Injection'
    },
    {
        :name => 'Session-Fixation',
        :summary => 'Session fixation'
    },
    {
        :name => 'Transport-Layer-Encryption',
        :summary => 'Insufficient Transport Layer Security'
    },
    {
        :name => 'Unauthorized-Access',
        :summary => 'Unauthorized access'
    },
    {
        :name => 'Unvalidated-Redirect',
        :summary => 'Unvalidated redirect'
    },
    {
        :name => 'Version',
        :summary => 'Vulnerable Version'
    },
    {
        :name => 'XSS',
        :summary => 'Cross-site scripting'
    }
]

metasploit_by_name = {}

metasploit_attributes.each do |attributes|
  name = attributes[:name]
  metasploit_by_name[name] = Web::VulnCategory::Metasploit.where(attributes).first_or_create!
end

# A (target, version, rank) uniquely identifies a {Web::VulnCategory::OWASP}, so key the (nested) hash by those
# attributes.
owasp_by_rank_by_version_by_target = Hash.new { |hash, target|
  hash[target] = Hash.new { |owasp_by_rank_by_version, version|
    owasp_by_rank_by_version[version] = {}
  }
}

#
# OWASP seeds sorted by Target, Version, and Rank.
#

owasp_attributes = [
    #
    # Application, 2010
    #

    {
        :detectability => 'average',
        :exploitability => 'easy',
        :impact => 'severe',
        :prevalence => 'common',
        :rank => 1,
        :summary => 'Injection',
        :target => 'Application',
        :version => '2010'
    },
    {
        :detectability => 'easy',
        :exploitability => 'average',
        :impact => 'moderate',
        :prevalence => 'very widespread',
        :rank => 2,
        :summary => 'Cross-Site Scripting (XSS)',
        :target => 'Application',
        :version => '2010'
    },
    {
        :detectability => 'average',
        :exploitability => 'average',
        :impact => 'severe',
        :prevalence => 'common',
        :rank => 3,
        :summary => 'Broken Authentication and Session Management',
        :target => 'Application',
        :version => '2010'
    },
    {
        :detectability => 'easy',
        :exploitability => 'easy',
        :impact => 'moderate',
        :prevalence => 'common',
        :rank => 4,
        :summary => 'Insecure Direct Object References',
        :target => 'Application',
        :version => '2010'
    },
    {
        :detectability => 'easy',
        :exploitability => 'average',
        :impact => 'moderate',
        :prevalence => 'widespread',
        :rank => 5,
        :summary => 'Cross-Site Request Forgery (CSRF)',
        :target => 'Application',
        :version => '2010'
    },
    {
        :detectability => 'easy',
        :exploitability => 'easy',
        :impact => 'moderate',
        :prevalence => 'common',
        :rank => 6,
        :summary => 'Security Misconfiguration',
        :target => 'Application',
        :version => '2010'
    },
    {
        :detectability => 'difficult',
        :exploitability => 'difficult',
        :impact => 'severe',
        :prevalence => 'uncommon',
        :rank => 7,
        :summary => 'Insecure Cryptographic Storage',
        :target => 'Application',
        :version => '2010'
    },
    {
        :detectability => 'average',
        :exploitability => 'easy',
        :impact => 'moderate',
        :prevalence => 'uncommon',
        :rank => 8,
        :summary => 'Failure to Restrict URL Access',
        :target => 'Application',
        :version => '2010'
    },
    {
        :detectability => 'easy',
        :exploitability => 'difficult',
        :impact => 'moderate',
        :prevalence => 'common',
        :rank => 9,
        :summary => 'Insufficient Transport Layer Protection',
        :target => 'Application',
        :version => '2010'
    },
    {
        :detectability => 'easy',
        :exploitability => 'average',
        :impact => 'moderate',
        :prevalence => 'uncommon',
        :rank => 10,
        :summary => 'Unvalidated Redirect and Forwards',
        :target => 'Application',
        :version => '2010'
    },

    #
    # Application, 2013rc1
    #

    {
        :detectability => 'average',
        :exploitability => 'easy',
        :impact => 'severe',
        :prevalence => 'common',
        :rank => 1,
        :summary => 'Injection',
        :target => 'Application',
        :version => '2013rc1'
    },
    {
        :detectability => 'average',
        :exploitability => 'average',
        :impact => 'severe',
        :prevalence => 'widespread',
        :rank => 2,
        :summary => 'Broken Authentication and Session Management',
        :target => 'Application',
        :version => '2013rc1'
    },
    {
        :detectability => 'easy',
        :exploitability => 'average',
        :impact => 'moderate',
        :prevalence => 'very widespread',
        :rank => 3,
        :summary => 'Cross-Site Scripting (XSS)',
        :target => 'Application',
        :version => '2013rc1'
    },
    {
        :detectability => 'easy',
        :exploitability => 'easy',
        :impact => 'moderate',
        :prevalence => 'common',
        :rank => 4,
        :summary => 'Insecure Direct Object References',
        :target => 'Application',
        :version => '2013rc1'
    },
    {
         :detectability => 'easy',
         :exploitability => 'easy',
         :impact => 'moderate',
         :prevalence => 'common',
         :rank => 5,
         :summary => 'Security Misconfiguration',
         :target => 'Application',
         :version => '2013rc1',
    },
    {
        :detectability => 'average',
        :exploitability => 'difficult',
        :impact => 'severe',
        :prevalence => 'uncommon',
        :rank => 6,
        :summary => 'Sensitive Data Exposure',
        :target => 'Application',
        :version => '2013rc1'
    },
    {
        :detectability => 'average',
        :exploitability => 'easy',
        :impact => 'moderate',
        :prevalence => 'common',
        :rank => 7,
        :summary => 'Missing Function Level Access Control',
        :target => 'Application',
        :version => '2013rc1'
    },
    {
        :detectability => 'easy',
        :exploitability => 'average',
        :impact => 'moderate',
        :prevalence => 'common',
        :rank => 8,
        :summary => 'Cross-Site Request Forgery (CSRF)',
        :target => 'Application',
        :version => '2013rc1'
    },
    {
        :detectability => 'difficult',
        :exploitability => 'average',
        :impact => 'moderate',
        :prevalence => 'widespread',
        :rank => 9,
        :summary => 'Using Components with Known Vulnerabilities',
        :target => 'Application',
        :version => '2013rc1'
    },
    {
        :detectability => 'easy',
        :exploitability => 'average',
        :impact => 'moderate',
        :prevalence => 'uncommon',
        :rank => 10,
        :summary => 'Unvalidated Redirect and Forwards',
        :target => 'Application',
        :version => '2013rc1'
    }
]

owasp_attributes.each do |attributes|
  target = attributes[:target]
  version = attributes[:version]
  rank = attributes[:rank]

  # search only by the unique columns so others can be updated
  scope = Web::VulnCategory::OWASP.where(:target => target, :version => version, :rank => rank)
  owasp = scope.first_or_initialize

  # Update attributes or set non-unique attributes for new records
  owasp.assign_attributes(attributes)

  owasp.save!

  owasp_by_rank_by_version_by_target[target][version][rank] = owasp
end

owasp_by_metasploit = {
  metasploit_by_name['CMDi'] => [
    owasp_by_rank_by_version_by_target['Application']['2010'][1],
    owasp_by_rank_by_version_by_target['Application']['2013rc1'][1]
  ],
  metasploit_by_name['CSRF'] => [
    owasp_by_rank_by_version_by_target['Application']['2010'][5],
    owasp_by_rank_by_version_by_target['Application']['2013rc1'][8]
  ],
  metasploit_by_name['Direct-Object-Reference'] => [
    owasp_by_rank_by_version_by_target['Application']['2010'][4],
    owasp_by_rank_by_version_by_target['Application']['2013rc1'][4]
  ],
  metasploit_by_name['Publicly-Writable-Directory'] => [
    owasp_by_rank_by_version_by_target['Application']['2010'][6],
    owasp_by_rank_by_version_by_target['Application']['2013rc1'][5]
  ],
  metasploit_by_name['SQLi'] => [
    owasp_by_rank_by_version_by_target['Application']['2010'][1],
    owasp_by_rank_by_version_by_target['Application']['2013rc1'][1]
  ],
  metasploit_by_name['Session-Fixation'] => [
    owasp_by_rank_by_version_by_target['Application']['2010'][3],
    owasp_by_rank_by_version_by_target['Application']['2013rc1'][2],
  ],
  metasploit_by_name['Transport-Layer-Encryption'] => [
      owasp_by_rank_by_version_by_target['Application']['2013rc1'][6]
  ],
  metasploit_by_name['Unauthorized-Access'] => [
    owasp_by_rank_by_version_by_target['Application']['2010'][8]
  ],
  metasploit_by_name['Unvalidated-Redirect'] => [
    owasp_by_rank_by_version_by_target['Application']['2010'][10],
    owasp_by_rank_by_version_by_target['Application']['2013rc1'][10]
  ],
  metasploit_by_name['Version'] => [
    owasp_by_rank_by_version_by_target['Application']['2010'][6],
    owasp_by_rank_by_version_by_target['Application']['2013rc1'][9]
  ],
  metasploit_by_name['XSS'] => [
    owasp_by_rank_by_version_by_target['Application']['2010'][2],
    owasp_by_rank_by_version_by_target['Application']['2013rc1'][3]
  ]
}

owasp_by_metasploit.each do |metasploit, owasps|
  owasps = Array.wrap(owasps)

  unless metasploit.is_a? Web::VulnCategory::Metasploit
    raise TypeError, 'metasploit is not a Web::VulnCategory::Metasploit'
  end

  owasps.each do |owasp|
    unless owasp.is_a? Web::VulnCategory::OWASP
      raise TypeError, 'owasp is not a Web::VulnCategory::Metasploit'
    end

    Web::VulnCategory::Projection::MetasploitOWASP.where(
        :metasploit_id => metasploit.id,
        :owasp_id => owasp.id
    ).first_or_create!
  end
end

# Creates static reference table of well-known ports,
# used for firewall egress data
# Truncate initially in case we have updated values
ApplicationRecord.connection.execute("truncate table known_ports RESTART IDENTITY;")

seeds_pathname = Pathname.new(__FILE__).parent.join('seeds')

CSV.foreach(seeds_pathname.join('known_ports.csv'), :headers => true) do |row|
  port = row['port'].to_i
  name = row['name'].tr("'", "")
  info = row['info'].tr("'", "") || ''
  ApplicationRecord.connection.execute("INSERT INTO known_ports (port, name, info) VALUES(#{port}, \'#{name}\', \'#{info}\')\;")
end

# truncates & resets the auto_increment id for apps table
ApplicationRecord.connection.execute("truncate table apps RESTART IDENTITY;")
ApplicationRecord.connection.execute("truncate table app_categories RESTART IDENTITY;")
ApplicationRecord.connection.execute("truncate table app_categories_apps RESTART IDENTITY;")
# loads the data regarding apps from the csv data file
CSV.foreach(seeds_pathname.join('apps.csv'), :headers => true) do |row|
  categories_array = JSON.parse(row['categories'].gsub("'", '"'))
  app = Apps::App.where(
    :name => row['name'],
    :description => row['description'],
    :rating => row['rating'],
    :symbol => row['symbol'],
    :hidden => row['hidden']
  ).first_or_create!
  categories_array.each do |cat|
    cat = Apps::AppCategory.where(name: cat).first_or_create
    unless app.app_categories.include? cat
      app.app_categories.push cat
      app.save
    end
  end
end
