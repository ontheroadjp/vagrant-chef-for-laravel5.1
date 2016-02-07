#
# Cookbook Name:: curl
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "build_tools"

# -------------------------------------
# Install cURL Source code
# -------------------------------------
package ["libssh2-devel","libcurl-devel","openssl-devel"] do
	action [:install, :upgrade]
end
remote_file "/usr/local/src/curl-7.47.0.tar.gz" do
    source 'http://curl.haxx.se/download/curl-7.47.0.tar.gz'
    not_if { ::File.exists?("/usr/local/src/curl-7.47.0.tar.gz")}
    action :create
end
execute "cURL - Untarball" do
    cwd "/usr/local/src"
    user "root"
    command "tar -xvzf curl-7.47.0.tar.gz"
    action :run
    only_if { ::File.exists?("/usr/local/src/curl-7.47.0.tar.gz")}
    not_if { ::File.exists?("/usr/local/src/curl-7.47.0")}
end
execute "cURL - ./configure" do
    cwd "/usr/local/src/curl-7.47.0"
    user "root"
    #environment(
    #    "USE_CCACHE" => "1",
    #    "CCACHE_DIR" => "/root/.ccache",
    #    "CC" => "ccache gcc",
    #    "CXX" => "ccache g++"
    #)
    command <<-EOH
        #./configure --prefix=/usr/local --with-ssl=/usr/local/openssl --with-libssh2
        ./configure --prefix=/usr/local --with-ssl --with-libssh2
        EOH
    action :run
end
execute "cURL make" do
    cwd "/usr/local/src/curl-7.47.0"
    user "root"
    #environment(
    #    "USE_CCACHE" => "1",
    #    "CCACHE_DIR" => "/root/.ccache",
    #    "CC" => "ccache gcc",
    #    "CXX" => "ccache g++"
    #)
    command "make -j8"
    action :run
end
execute "cURL make install" do
    cwd "/usr/local/src/curl-7.47.0"
    user "root"
    command "make install"
    action :run
end
#execute 'cURL set sim links' do
#    cwd "/usr/local/bin"
#    user 'root'
#    command "ln -fs /usr/local/cURL/bin/* ./"
#    action :run
#end

