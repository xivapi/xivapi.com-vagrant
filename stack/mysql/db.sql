CREATE DATABASE xivapi;
CREATE USER xivapi@localhost IDENTIFIED BY 'xivapi';
GRANT ALL PRIVILEGES ON *.* TO xivapi@'%' IDENTIFIED BY 'xivapi';
GRANT ALL PRIVILEGES ON *.* TO xivapi@localhost IDENTIFIED BY 'xivapi';
FLUSH PRIVILEGES;