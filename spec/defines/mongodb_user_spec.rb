require 'spec_helper'

describe 'mongodb::user', :type => :define do
  context "user scripts directory" do
    describe "creates the default directory location" do
      let(:title) { 'creates directory for user js scripts' }
      let(:params) {{
        :password => "some_password",
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
        :password => "some_password",
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
end
