require 'spec_helper'

describe 'mongodb::user', :type => :define do
  let(:password) { 'some_password' }

  context "user scripts directory" do
    describe "creates the default directory location" do
      let(:title) { 'creates directory for user js scripts' }
      let(:path) { '/root/puppet-mongodb' }
      let(:params) {{
        :password => password,
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
      let(:path) { '/root/puppet-mongodb' }
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
      let(:path) { '/root/puppet-mongodb' }
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

  context "creating users within mongo auth" do
    describe "runs the user script to add a given user" do
      let(:title) { 'joe_bloggs' }
      let(:exec) { "mongo_user-#{title}_test" }
      let(:file) { "#{exec}.js" }
      let(:path) { '/root/puppet-mongodb' }
      let(:params) {{
        :password => password
      }}

      it {
        should contain_exec(exec).with(
                 'command'     => "mongo 127.0.0.1:27017/test /root/puppet-mongodb/#{file}",
                 'require'     => 'Service[mongodb]',
                 'subscribe'   => "File[#{file}]",
                 'path'        => ['/usr/bin', '/usr/sbin'],
                 'refreshonly' => 'true')
      }
    end

    describe "runs the user script to add a user for the given database" do
      let(:title) { 'joe_bloggs' }
      let(:database) { 'some_database' }
      let(:exec) { "mongo_user-#{title}_#{database}" }
      let(:file) { "#{exec}.js" }
      let(:path) { '/root/puppet-mongodb' }
      let(:params) {{
        :password => password,
        :db_name  => database
      }}

      it {
        should contain_exec(exec).with(
                 'command'     => "mongo 127.0.0.1:27017/#{database} /root/puppet-mongodb/#{file}",
                 'require'     => 'Service[mongodb]',
                 'subscribe'   => "File[#{file}]",
                 'path'        => ['/usr/bin', '/usr/sbin'],
                 'refreshonly' => 'true')
      }
    end
  end
end
