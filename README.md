# Perl Simple DotEnv
load enviroment vaiabled with Perl from a file in `.env` (dotenv) format. 

## Server Install
Install the module you Perl module path. 
1. load module and call sub source_dotenv();
```
use DotenvSimple;
DotenvSimple::source_dotenv('/tmp/.env');
```
2. Here's a sample `/tmp/.env`, can follow any of the below formats
```
# <--- hashes or comments are ignored
# we also ignore export, white spaces and semicolons
export  DD_DATABASE_NAME = issm_lists_stage;
# single and double quotes for values are allowed
DD_DATABASE_USER=dev
DD_DATABASE_PASSWD=dev
DD_DATABASE_HOST='192.168.33.1'
DD_DATABASE_PORT='3306';
DD_DATABASE_Type = "mysql";
```

Refferancing key a key to get teh value from the above `.env` files:

`print $ENV{DD_DATABASE_HOST};`
output > `192.168.33.1`

#### Options
Loading dotenv in this order. Once found it will stop searching for dotenv.
1. You pass the path of you dotenv file as a parameter `DotenvSimple::source_dotenv('/tmp/.env');`
2. If you set a Perl accessable enviroment parameter `$ENV{DOTENV_FILE}` the subroutine will use the value of this vaiable. Use case would be to define this in apache vhost configs like so
```
<VirtualHost hostname:80>
   ...
   SetEnv DOTENV_FILE /tmp/.env
   ...
</VirtualHost>
```
3. Generally when using Apache, the document root variable `$ENV{DOCUMENT_ROOT}`, is loaded into perl. if using HTTPD it will also search for `.env` in your document root. 

