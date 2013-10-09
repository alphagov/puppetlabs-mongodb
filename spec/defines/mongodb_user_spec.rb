require 'spec_helper'

describe 'mongodb::user', :type => :define do
  let(:password) { 'some_password' }
  let(:database) { 'test' }
  let(:path) { '/root/puppetlabs-mongodb' }

  context "user scripts directory" do
    describe "creates the default directory location" do
      let(:title) { 'creates directory for user js scripts' }
      let(:params) {{
        :db_name  => database,
        :password => password
      }}

      it {
        should contain_file(path).with(
                 'ensure' => 'directory',
                 'group'  => 'root',
                 'mode'   => '0700',
                 'owner'  => 'root',
                 'path'   => path)
      }
    end

    describe "allows user overriding of the user scripts directory" do
      let(:title) { 'creates directory for user js scripts' }
      let(:some_new_path) { '/some_new_path' }
      let(:params) {{
        :db_name  => database,
        :password => password,
        :js_dir   => some_new_path
      }}

      it {
        should contain_file(some_new_path).with(
                 'ensure' => 'directory',
                 'group'  => 'root',
                 'mode'   => '0700',
                 'owner'  => 'root',
                 'path'   => some_new_path)
      }
    end
  end

  context "user script create file for user" do
    describe "creates a default user create script for the 'test' database" do
      let(:title) { 'joe_bloggs' }
      let(:file) { "mongo_user-#{title}_test.js" }
      let(:content) { "// File created by Puppet\ndb.addUser(\"#{title}\", \"#{password}\", []);\n" }
      let(:params) {{
        :db_name  => database,
        :password => password
      }}

      it {
        should contain_file(file).with(
                 'content' => content,
                 'ensure'  => 'present',
                 'group'   => 'root',
                 'mode'    => '0600',
                 'owner'   => 'root',
                 'path'    => "#{path}/#{file}")
      }
    end

    describe "creates a user js file for the 'some_db_i_haz' database" do
      let(:title) { 'joe_bloggs' }
      let(:database) { 'some_db_i_haz' }
      let(:file) { "mongo_user-#{title}_#{database}.js" }
      let(:content) { "// File created by Puppet\ndb.addUser(\"#{title}\", \"#{password}\", []);\n" }
      let(:params) {{
        :db_name  => database,
        :password => password
      }}

      it {
        should contain_file(file).with(
                 'content' => content,
                 'ensure'  => 'present',
                 'group'   => 'root',
                 'mode'    => '0600',
                 'owner'   => 'root',
                 'path'    => "#{path}/#{file}")
      }
    end
  end

  context "creating users within mongo auth" do
    describe "runs the user script to add a given user" do
      let(:title) { 'joe_bloggs' }
      let(:exec) { "mongo_user-#{title}_test" }
      let(:file) { "#{exec}.js" }
      let(:params) {{
        :db_name  => database,
        :password => password
      }}

      it {
        should contain_exec(exec).with(
                 'command'     => "mongo 127.0.0.1:27017/test #{path}/#{file}",
                 'path'        => ['/usr/bin', '/usr/sbin'],
                 'refreshonly' => 'true',
                 'require'     => 'Service[mongodb]',
                 'subscribe'   => "File[#{file}]")
      }
    end

    describe "runs the user script to add a user for the given database" do
      let(:title) { 'joe_bloggs' }
      let(:database) { 'some_database' }
      let(:exec) { "mongo_user-#{title}_#{database}" }
      let(:file) { "#{exec}.js" }
      let(:params) {{
        :db_name  => database,
        :password => password
      }}

      it {
        should contain_exec(exec).with(
                 'command'     => "mongo 127.0.0.1:27017/#{database} #{path}/#{file}",
                 'path'        => ['/usr/bin', '/usr/sbin'],
                 'refreshonly' => 'true',
                 'require'     => 'Service[mongodb]',
                 'subscribe'   => "File[#{file}]")
      }
    end
  end
end
