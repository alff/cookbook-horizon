require "spec_helper"

describe "horizon::db" do
  it "installs mysql packages" do
    @chef_run = converge

    expect(@chef_run).to include_recipe "mysql::client"
    expect(@chef_run).to include_recipe "mysql::ruby"
  end

  it "creates database and user" do
    ::Chef::Recipe.any_instance.should_receive(:db_create_with_user).
      with "dashboard", "dash", "test-pass"

    converge
  end

  def converge
    ::Chef::Recipe.any_instance.stub(:db_password).with("horizon").
      and_return "test-pass"

    ::ChefSpec::ChefRunner.new(
      :platform  => "ubuntu",
      :version   => "12.04",
      :log_level => ::LOG_LEVEL
    ).converge "horizon::db"
  end
end
