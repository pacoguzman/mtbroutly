CREATE TABLE `abuses` (
  `id` int(11) NOT NULL auto_increment,
  `email` varchar(255) default NULL,
  `title` varchar(255) default NULL,
  `referer` varchar(255) default NULL,
  `description` varchar(255) default NULL,
  `confirmed` tinyint(1) default '0',
  `resource_id` int(11) default NULL,
  `resource_type` varchar(255) default NULL,
  `created_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `activities` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `action` varchar(255) default NULL,
  `item_id` int(11) default NULL,
  `item_type` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_activities_on_item_type_and_item_id` (`item_type`,`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `client_applications` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `url` varchar(255) default NULL,
  `support_url` varchar(255) default NULL,
  `callback_url` varchar(255) default NULL,
  `key` varchar(50) default NULL,
  `secret` varchar(50) default NULL,
  `user_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_client_applications_on_key` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `comments` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(50) default '',
  `comment` text,
  `created_at` datetime NOT NULL,
  `commentable_id` int(11) NOT NULL default '0',
  `user_id` int(11) NOT NULL default '0',
  `commentable_type` varchar(255) NOT NULL default '',
  `approved` tinyint(1) default '0',
  `name` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `url` varchar(255) default NULL,
  `spam` tinyint(1) default '0',
  PRIMARY KEY  (`id`),
  KEY `fk_comments_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `config` (
  `id` int(11) NOT NULL auto_increment,
  `key` varchar(255) NOT NULL default '',
  `value` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `key` (`key`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8;

CREATE TABLE `favorites` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `favoriteable_id` int(11) default NULL,
  `favoriteable_type` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_favorites_on_user_id` (`user_id`),
  KEY `index_favorites_on_favoriteable_type_and_favoriteable_id` (`favoriteable_type`,`favoriteable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `folders` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `user_id` int(11) default NULL,
  `deletable` tinyint(1) default '0',
  `folder_type` varchar(255) default NULL,
  `lock_version` int(11) default '0',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `friendships` (
  `id` int(11) NOT NULL auto_increment,
  `inviter_id` int(11) default NULL,
  `invited_id` int(11) default NULL,
  `status` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `group_sharings` (
  `id` int(11) NOT NULL auto_increment,
  `group_id` int(11) default NULL,
  `shareable_id` int(11) default NULL,
  `shareable_type` varchar(255) default NULL,
  `shared_by` int(11) default NULL,
  `status` int(11) default '1',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `groups` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `description` varchar(255) default NULL,
  `state` varchar(255) default NULL,
  `private` tinyint(1) default NULL,
  `moderated` tinyint(1) default '0',
  `user_id` int(11) default NULL,
  `activation_code` varchar(40) default NULL,
  `activated_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `image_file_name` varchar(255) default NULL,
  `image_content_type` varchar(255) default NULL,
  `image_file_size` int(11) default NULL,
  `image_updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `memberships` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `group_id` int(11) default NULL,
  `moderator` tinyint(1) default '0',
  `state` varchar(255) default NULL,
  `activation_code` varchar(40) default NULL,
  `activated_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `message_readings` (
  `id` int(11) NOT NULL auto_increment,
  `message_id` int(11) default NULL,
  `user_id` int(11) default NULL,
  `read_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `messages` (
  `id` int(11) NOT NULL auto_increment,
  `subject` varchar(255) default NULL,
  `content` text,
  `folder_id` int(11) default NULL,
  `is_read` tinyint(1) default '0',
  `from_user_id` int(11) default NULL,
  `to_user_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `oauth_nonces` (
  `id` int(11) NOT NULL auto_increment,
  `nonce` varchar(255) default NULL,
  `timestamp` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_oauth_nonces_on_nonce_and_timestamp` (`nonce`,`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `oauth_tokens` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `type` varchar(20) default NULL,
  `client_application_id` int(11) default NULL,
  `token` varchar(50) default NULL,
  `secret` varchar(50) default NULL,
  `authorized_at` datetime default NULL,
  `invalidated_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_oauth_tokens_on_token` (`token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `plugin_schema_migrations` (
  `plugin_name` varchar(255) default NULL,
  `version` varchar(255) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `profiles` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `first_name` varchar(255) default NULL,
  `last_name` varchar(255) default NULL,
  `website` varchar(255) default NULL,
  `blog` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `icon_file_name` varchar(255) default NULL,
  `icon_content_type` varchar(255) default NULL,
  `icon_file_size` int(11) default NULL,
  `icon_updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `rates` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `rateable_id` int(11) default NULL,
  `rateable_type` varchar(255) default NULL,
  `stars` int(11) default NULL,
  `dimension` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_rates_on_user_id` (`user_id`),
  KEY `index_rates_on_rateable_id` (`rateable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `ratings` (
  `id` int(11) NOT NULL auto_increment,
  `rating` int(11) default NULL,
  `rateable_id` int(11) NOT NULL,
  `rateable_type` varchar(255) NOT NULL,
  `user_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_ratings_on_rateable_id_and_rating` (`rateable_id`,`rating`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `routes` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) default NULL,
  `description` text,
  `user_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `distance` decimal(10,3) default '0.000',
  `distance_unit` varchar(255) default 'km',
  `loops` int(11) default '1',
  `encoded_points` text,
  `lat` decimal(15,10) default '0.0000000000',
  `lng` decimal(15,10) default '0.0000000000',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `taggings` (
  `id` int(11) NOT NULL auto_increment,
  `tag_id` int(11) default NULL,
  `taggable_id` int(11) default NULL,
  `taggable_type` varchar(255) default NULL,
  `created_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_taggings_on_tag_id` (`tag_id`),
  KEY `index_taggings_on_taggable_id_and_taggable_type` (`taggable_id`,`taggable_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `tags` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `login` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `crypted_password` varchar(40) default NULL,
  `salt` varchar(40) default NULL,
  `activation_code` varchar(40) default NULL,
  `password_reset_code` varchar(255) default NULL,
  `remember_token` varchar(255) default NULL,
  `remember_token_expires_at` datetime default NULL,
  `activated_at` datetime default NULL,
  `deleted_at` datetime default NULL,
  `state` varchar(255) default 'passive',
  `admin` tinyint(1) default '0',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `waypoints` (
  `id` int(11) NOT NULL auto_increment,
  `address` varchar(100) default NULL,
  `lat` decimal(15,10) default NULL,
  `lng` decimal(15,10) default NULL,
  `alt` decimal(5,5) default NULL,
  `locatable_id` int(11) default NULL,
  `locatable_type` varchar(255) default NULL,
  `position` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO schema_migrations (version) VALUES ('20090304205818');

INSERT INTO schema_migrations (version) VALUES ('20090304210137');

INSERT INTO schema_migrations (version) VALUES ('20090304210447');

INSERT INTO schema_migrations (version) VALUES ('20090304210702');

INSERT INTO schema_migrations (version) VALUES ('20090304210830');

INSERT INTO schema_migrations (version) VALUES ('20090304211106');

INSERT INTO schema_migrations (version) VALUES ('20090304211109');

INSERT INTO schema_migrations (version) VALUES ('20090304215626');

INSERT INTO schema_migrations (version) VALUES ('20090304215853');

INSERT INTO schema_migrations (version) VALUES ('20090308193945');

INSERT INTO schema_migrations (version) VALUES ('20090402215446');

INSERT INTO schema_migrations (version) VALUES ('20090410153212');

INSERT INTO schema_migrations (version) VALUES ('20090515153215');

INSERT INTO schema_migrations (version) VALUES ('20090628141627');