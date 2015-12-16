nginx_conf_path = '/etc/nginx/conf.d'

apt_repository 'nignx' do
  uri 'http://nginx.org/packages/mainline/ubuntu/'
  distribution 'trusty'
  components ['nginx']
  key 'http://nginx.org/keys/nginx_signing.key'
  notifies :run, 'execute[apt-get update]', :immediately
end

package 'nginx' do
  version "#{node[:nginx][:version]}*"
end

service 'nginx' do
  action :stop
end

Dir.glob("#{nginx_conf_path}/*.conf") do |conf_file|
  file conf_file do
    action :delete
  end
end

template "#{nginx_conf_path}/gabortakacs.conf" do
  source 'gabortakacs.conf'
end

site_root = '/var/www/gabortakacs_com'

directory site_root do
  recursive true
end

package 'git'

git "#{site_root}/letsencrypt" do
  repository 'https://github.com/letsencrypt/letsencrypt'
  action :sync
end

directory '/etc/nginx/ssl'

execute 'get_ssl_cert' do
  cwd "#{site_root}/letsencrypt"
  command './letsencrypt-auto certonly --standalone -d gabortakacs.com --email me@gabortakacs.com --agree-tos'
  not_if "#{File.exists?('/etc/letsencrypt/live/gabortakacs.com/fullchain.pem')}"
end

service 'nginx' do
  action :start
end
