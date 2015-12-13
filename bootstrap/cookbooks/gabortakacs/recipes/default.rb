nginx_conf_path = '/etc/nginx/conf.d'

service 'nginx' do
  supports status: true, restart: true, reload: true
  action :nothing
end

file "#{nginx_conf_path}/default.conf" do
  action :delete
end

template "#{nginx_conf_path}/gabortakacs.conf" do
  source 'gabortakacs.conf'
  notifies :restart, 'service[nginx]', :immediately
end

directory "/var/www/gabortakacs_com/" do
  recursive true
end

package 'git'
