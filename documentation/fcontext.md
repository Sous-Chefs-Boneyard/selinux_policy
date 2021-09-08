# fcontext

Allows managing the SELinux context of files. This can be used to grant SELinux-protected daemons access to additional / moved files.

Actions:

- `addormodify` (default): Assigns the file regexp to the right context, whether it's already listed another context or not at all.
- `add`: Assigns the file regexp to the right context it's if not listed (only uses -a).
- `modify`: Changes the file regexp context if it's already listed (only uses -m).
- `delete`: Removes the file regexp context if it's listed (uses -d).

Properties:

- `file_spec`: This is the file regexp in question, defaults to resource name.
- `secontext`: The SELinux context to assign the file regexp to. Not required for `:delete`
- `file_type`: Restrict the fcontext to specific file types. See the table below for an overview. See also <https://en.wikipedia.org/wiki/Unix_file_types> for more info
- **a** All files
- **f** Regular files
- **d** Directory
- **c** Character device
- **b** Block device
- **s** Socket
- **l** Symbolic link
- **p** Namedpipe

Example usage (see mysql cookbook for example daemons ):

```ruby
include_recipe 'selinux_policy::install'

# Allow http servers (nginx/apache) to modify moodle files
selinux_policy_fcontext '/var/www/moodle(/.*)?' do
  secontext 'httpd_sys_rw_content_t'
end

# Allow a custom mysql daemon to access its files.
{'mysqld_etc_t' => "/etc/mysql-#{service_name}(/.*)?",
'mysqld_etc_t' => "/etc/mysql-#{service_name}/my\.cnf",
'mysqld_log_t' => "/var/log/mysql-#{service_name}(/.*)?",
'mysqld_db_t' => "/opt/mysql_data_#{service_name}(/.*)?",
'mysqld_var_run_t' => "/var/run/mysql-#{service_name}(/.*)?",
'mysqld_initrc_exec_t' => "/etc/rc\.d/init\.d/mysql-#{service_name}"}.each do |sc, f|
  selinux_policy_fcontext f do
    secontext sc
  end
end

# Adapt a symbolic link
selinux_policy_fcontext '/var/www/symlink_to_webroot' do
  secontext 'httpd_sys_rw_content_t'
  filetype 'l'
end
```
