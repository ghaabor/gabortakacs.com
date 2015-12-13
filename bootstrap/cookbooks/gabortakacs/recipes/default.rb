nginx_conf_path = '/etc/nginx/conf.d'

service 'nginx' do
  action :stop
end

file "#{nginx_conf_path}/default.conf" do
  action :delete
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

unless File.exists? '/etc/letsencrypt/live/gabortakacs.com/fullchain.pem'
  execute 'get_ssl_cert' do
    cwd "#{site_root}/letsencrypt"
    command './letsencrypt-auto certonly --standalone -d gabortakacs.com --email me@gabortakacs.com --agree-tos'
  end
end

service 'nginx' do
  action :start
end
