# selinux_policy_fcontext

Allows managing the SELinux context of files. This can be used to grant SELinux-protected daemons access to additional / moved files.

## Actions

| Action         | Description                                                                  |
|----------------|------------------------------------------------------------------------------|
| `:add`         | Assigns the  file to the right context if not listed (only uses `-a`).       |
| `:addormodify` | Default. Assigns the file to the right context regardless of previous state. |
| `:delete`      | Removes the  file's context if listed (uses `-d`).                           |
| `:modify`      | Changes the  file's context if already listed (only uses `-m`).              |
| `:relabel`     | Restores context on the file or directory using `restorecon`.                |

## Properties

| Name             | Type          | Default       | Description                                                                                                                                                                    |
|------------------|---------------|---------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `file_spec`      | String, Regex | Resource name | Path or regular expression to files to modify.                                                                                                                                 |
| `secontext`      | String        |               | The SELinux context to assign the file to.                                                                                                                                     |
| `file_type`      | String        |               | Restrict the resource to only modifying specific file types. See list below or [https://en.wikipedia.org/wiki/Unix_file_types](https://en.wikipedia.org/wiki/Unix_file_types). |
| `allow_disabled` | Boolean       | `true`        | Whether to skip the resource if SELinux is not enabled.                                                                                                                        |

Supported file types:

- **`a`** - All files
- **`f`** - Regular files
- **`d`** - Directory
- **`c`** - Character device
- **`b`** - Block device
- **`s`** - Socket
- **`l`** - Symbolic link
- **`p`** - Named pipe

## Examples

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
