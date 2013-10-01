require 'spec_helper'

describe 'mongodb::user', :type => :define do
  let(:password) { 'some_password' }

  context "user scripts directory" do
    describe "creates the default directory location" do
      let(:title) { 'creates directory for user js scripts' }
      let(:params) {{
        :password => password,
      }}

      it {
        path = '/root/puppetlabs-mongodb'

        should contain_file(path).with(
                 'ensure' => 'directory',
                 'path'   => path,
                 'owner'  => 'root',
                 'group'  => 'root',
                 'mode'   => '0700')
      }
    end

    describe "allows user overriding of the user scripts directory" do
      let(:title) { 'creates directory for user js scripts' }
      let(:path) { '/some_new_path' }
      let(:params) {{
        :password => password,
        :js_dir   => path,
      }}

      it {
        should contain_file(path).with(
                 'ensure' => 'directory',
                 'path'   => path,
                 'owner'  => 'root',
                 'group'  => 'root',
                 'mode'   => '0700')
      }
    end
  end

  context "user script create file for user" do
    describe "creates a default user create script for the 'test' database" do
      let(:title) { 'joe_bloggs' }
      let(:file) { "mongo_user-#{title}_test.js" }
      let(:path) { '/root/puppetlabs-mongodb' }
      let(:content) { "// File created by Puppet\ndb.addUser(\"#{title}\", \"#{password}\", []);\n" }
      let(:params) {{
        :password => password
      }}

      it {
        should contain_file(file).with(
                 'ensure'  => 'present',
                 'path'    => "#{path}/#{file}",
                 'owner'   => 'root',
                 'group'   => 'root',
                 'mode'    => '0600',
                 'content' => content)
      }
    end

    describe "creates a user js file for the 'some_db_i_haz' database" do
      let(:title) { 'joe_bloggs' }
      let(:database) { 'some_db_i_haz' }
      let(:file) { "mongo_user-#{title}_#{database}.js" }
      let(:path) { '/root/puppetlabs-mongodb' }
      let(:content) { "// File created by Puppet\ndb.addUser(\"#{title}\", \"#{password}\", []);\n" }
      let(:params) {{
        :password => password,
        :db_name  => database
      }}

      it {
        should contain_file(file).with(
                 'ensure'  => 'present',
                 'path'    => "#{path}/#{file}",
                 'owner'   => 'root',
                 'group'   => 'root',
                 'mode'    => '0600',
                 'content' => content)
      }
    end
  end
end
