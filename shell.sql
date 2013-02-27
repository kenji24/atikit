-- phpMyAdmin SQL Dump
-- version 3.5.2.2
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Feb 27, 2013 at 03:08 AM
-- Server version: 5.5.27
-- PHP Version: 5.4.7

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `atikit`
--

-- --------------------------------------------------------

--
-- Table structure for table `companies`
--

CREATE TABLE IF NOT EXISTS `companies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_name` varchar(50) DEFAULT NULL,
  `company_address` varchar(100) DEFAULT NULL,
  `company_address2` varchar(30) DEFAULT NULL,
  `company_city` varchar(30) DEFAULT NULL,
  `company_state` varchar(2) DEFAULT NULL,
  `company_zip` varchar(10) DEFAULT NULL,
  `company_admin` int(11) DEFAULT NULL,
  `company_isprovider` tinyint(1) DEFAULT '0',
  `company_notes` varchar(1024) DEFAULT NULL,
  `company_stripetoken` varchar(100) DEFAULT NULL,
  `company_dwollatoken` varchar(100) DEFAULT NULL,
  `company_stripeid` varchar(100) DEFAULT NULL,
  `company_plan` int(11) NOT NULL,
  `company_phone` varchar(20) DEFAULT NULL,
  `company_vip` tinyint(1) DEFAULT '0',
  `company_since` bigint(20) DEFAULT NULL,
  `company_planbegin` bigint(20) DEFAULT NULL,
  `company_planend` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `companies`
--

INSERT INTO `companies` (`id`, `company_name`, `company_address`, `company_address2`, `company_city`, `company_state`, `company_zip`, `company_admin`, `company_isprovider`, `company_notes`, `company_stripetoken`, `company_dwollatoken`, `company_stripeid`, `company_plan`, `company_phone`, `company_vip`, `company_since`, `company_planbegin`, `company_planend`) VALUES
(1, 'test', 'test', 'test', 'test', 'te', '9000', 1, 1, NULL, NULL, NULL, NULL, 0, '', 0, 1361869952, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `files`
--

CREATE TABLE IF NOT EXISTS `files` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `file_loc` varchar(75) DEFAULT NULL,
  `file_title` varchar(75) DEFAULT NULL,
  `ticket_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `file_type` varchar(50) DEFAULT NULL,
  `file_ts` bigint(20) DEFAULT NULL,
  `file_sent` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `levels`
--

CREATE TABLE IF NOT EXISTS `levels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `level_name` varchar(30) DEFAULT NULL,
  `level_isbilling` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `levels`
--

INSERT INTO `levels` (`id`, `level_name`, `level_isbilling`) VALUES
(1, 'level1', 1);

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE IF NOT EXISTS `notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `notification_ts` bigint(20) DEFAULT NULL,
  `notification_body` varchar(125) DEFAULT NULL,
  `notification_isadmin` tinyint(1) DEFAULT '0',
  `notification_isbilling` tinyint(1) DEFAULT '0',
  `notification_from` int(11) DEFAULT NULL,
  `notification_title` varchar(75) DEFAULT NULL,
  `notification_active` tinyint(1) DEFAULT '0',
  `notification_url` varchar(50) DEFAULT NULL,
  `notification_popped` tinyint(1) DEFAULT '0',
  `notification_viewed` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `plans`
--

CREATE TABLE IF NOT EXISTS `plans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `plan_id` varchar(50) DEFAULT NULL,
  `plan_name` varchar(50) DEFAULT NULL,
  `plan_amount` double DEFAULT NULL,
  `plan_interval` int(11) DEFAULT NULL,
  `plan_trial` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `projects`
--

CREATE TABLE IF NOT EXISTS `projects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `queues`
--

CREATE TABLE IF NOT EXISTS `queues` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `queue_name` varchar(30) DEFAULT NULL,
  `queue_levels` varchar(50) DEFAULT NULL,
  `queue_email` varchar(100) DEFAULT NULL,
  `queue_host` varchar(100) DEFAULT NULL,
  `queue_password` varchar(100) DEFAULT NULL,
  `queue_lastmessage` varchar(200) DEFAULT NULL,
  `queue_islocked` tinyint(1) DEFAULT '1',
  `queue_icon` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `queues`
--

INSERT INTO `queues` (`id`, `queue_name`, `queue_levels`, `queue_email`, `queue_host`, `queue_password`, `queue_lastmessage`, `queue_islocked`, `queue_icon`) VALUES
(1, 'q1', '1', 'kenjimagto@gmail.com', 'test.local', 'ioioio', NULL, 1, 'ioioio'),
(2, 'q2', '1', 'info@test.local', 'test.local', 'ioioio', NULL, 1, 'ioioio');

-- --------------------------------------------------------

--
-- Table structure for table `replies`
--

CREATE TABLE IF NOT EXISTS `replies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ticket_id` int(11) DEFAULT NULL,
  `reply_ts` bigint(20) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `reply_body` varchar(2048) DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL,
  `reply_isinternal` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE IF NOT EXISTS `settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `setting_var` varchar(100) DEFAULT NULL,
  `setting_val` varchar(1024) DEFAULT NULL,
  `setting_desc` varchar(90) DEFAULT NULL,
  `setting_help` varchar(90) DEFAULT NULL,
  `setting_type` varchar(30) DEFAULT 'input',
  `setting_cat` varchar(30) DEFAULT NULL,
  `setting_span` int(11) DEFAULT '3',
  `setting_options` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=17 ;

--
-- Dumping data for table `settings`
--

INSERT INTO `settings` (`id`, `setting_var`, `setting_val`, `setting_desc`, `setting_help`, `setting_type`, `setting_cat`, `setting_span`, `setting_options`) VALUES
(1, 'stripe_publish', '', 'Stripe Publishable Key', 'This key is shown as the publishable key from your stripe account', 'input', 'Stripe', 3, NULL),
(2, 'stripe_private', '', 'Stripe Private Key', 'This key is shown as the PRIVATE key from your stripe account', 'input', 'Stripe', 3, NULL),
(3, 'mycompany', '', 'Your Company Name', 'This will be shown on invoices, etc.', 'input', 'General', 3, NULL),
(4, 'defaultEmail', '', 'Default E-mail Address:', 'Use an info address, or support, etc.', 'input', 'General', 3, NULL),
(5, 'defaultName', '', 'Default E-mail Name:', 'Your Company Name, Support, Info, Etc.', 'input', 'General', 3, NULL),
(6, 'company_logo', '', 'Company Logo for Invoices', 'This logo should be around 250x250 px', 'input', 'General', 3, NULL),
(7, 'atikit_url', '', 'aTikit URL', 'What is the default URL for aTikit. (ie. http://www.support.yourcompany.com/', 'input', 'General', 3, NULL),
(9, 'dwolla_app_key', '', 'Dwolla Application Key', 'Your Application Key from Dwolla', 'input', 'Dwolla', 4, NULL),
(10, 'dwolla_app_secret', '', 'Dwolla Application Secret', 'Your Application Secret from Dwolla', 'input', 'Dwolla', 4, NULL),
(11, 'dwolla_id', '', 'Dwolla Account ID', 'The ID of your Dwolla Account to receive money.', 'input', 'Dwolla', 2, NULL),
(12, 'signature', '', 'Default Signature', 'Default signature for outgoing emails from aTikit', 'textarea', 'General', 3, NULL),
(13, 'vitelity_user', '', 'Vitelity API Username', 'Your Vitelity API Username', 'input', 'Vitelity', 3, NULL),
(14, 'vitelity_password', '', 'Vitelity API Password', 'Your Vitelity API Password', 'password', 'Vitelity', 3, NULL),
(15, 'vitelity_sms', '', 'Vitelity SMS Number', 'Your SMS Enabled DID (1-xxx-xxx-xxxx)', 'input', 'Vitelity', 3, NULL),
(16, 'notify_sms', '', 'Numbers to SMS (separated by commas)', 'List all numbers for VIP texts (1-xxx-xxx-xxxx)', 'input', 'General', 3, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `sows`
--

CREATE TABLE IF NOT EXISTS `sows` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ticket_id` int(11) DEFAULT NULL,
  `sow_title` varchar(50) DEFAULT NULL,
  `sow_accepted` tinyint(1) DEFAULT '0',
  `sow_acceptuid` int(11) DEFAULT NULL,
  `sow_acceptts` bigint(20) DEFAULT NULL,
  `sow_meta` text,
  `sow_updated` bigint(20) DEFAULT NULL,
  `sow_updatedby` int(11) DEFAULT NULL,
  `sow_sent` tinyint(1) DEFAULT '0',
  `sow_hash` varchar(100) DEFAULT NULL,
  `sow_loc` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `subtickets`
--

CREATE TABLE IF NOT EXISTS `subtickets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ticket_id` int(11) DEFAULT NULL,
  `subticket_title` varchar(100) DEFAULT NULL,
  `subticket_body` varchar(2048) DEFAULT NULL,
  `subticket_meta` text,
  `subticket_isclosed` tinyint(1) DEFAULT '0',
  `subticket_lastupdated` bigint(20) DEFAULT NULL,
  `subticket_assigned` int(11) DEFAULT NULL,
  `subticket_standing` varchar(500) DEFAULT NULL,
  `subticket_standinguid` int(11) DEFAULT NULL,
  `subticket_standingperc` int(11) DEFAULT NULL,
  `subticket_creator` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `tickets`
--

CREATE TABLE IF NOT EXISTS `tickets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `queue_id` int(11) NOT NULL,
  `ticket_title` varchar(100) DEFAULT NULL,
  `ticket_body` varchar(2048) DEFAULT NULL,
  `ticket_isclosed` tinyint(1) DEFAULT '0',
  `ticket_status` varchar(30) DEFAULT NULL,
  `ticket_opents` bigint(20) DEFAULT NULL,
  `ticket_lastupdated` bigint(20) DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL,
  `ticket_assigned` int(11) DEFAULT NULL,
  `ticket_standing` varchar(500) DEFAULT NULL,
  `ticket_standinguid` int(11) DEFAULT NULL,
  `ticket_standingts` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `tickets`
--

INSERT INTO `tickets` (`id`, `queue_id`, `ticket_title`, `ticket_body`, `ticket_isclosed`, `ticket_status`, `ticket_opents`, `ticket_lastupdated`, `company_id`, `ticket_assigned`, `ticket_standing`, `ticket_standinguid`, `ticket_standingts`) VALUES
(1, 1, 'te', 'te', 0, 'New', 1361873676, 1361873676, 1, NULL, NULL, NULL, NULL),
(2, 2, 'rtytrytry', 'rtytrytrytry', 0, 'New', 1361873703, 1361873703, 1, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--

CREATE TABLE IF NOT EXISTS `transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `transaction_merchant_id` varchar(50) DEFAULT NULL,
  `transaction_ts` bigint(20) DEFAULT NULL,
  `transaction_amount` double DEFAULT NULL,
  `transaction_fee` double DEFAULT NULL,
  `transaction_net` double DEFAULT NULL,
  `transaction_source` varchar(30) DEFAULT NULL,
  `transaction_desc` varchar(90) DEFAULT NULL,
  `ticket_id` int(11) DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `transfers`
--

CREATE TABLE IF NOT EXISTS `transfers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `transfer_amt` double DEFAULT NULL,
  `transfer_ts` bigint(20) DEFAULT NULL,
  `transfer_source` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(50) DEFAULT NULL,
  `company_id` int(11) NOT NULL,
  `user_email` varchar(150) DEFAULT NULL,
  `user_phone` varchar(25) DEFAULT NULL,
  `user_title` varchar(25) DEFAULT NULL,
  `user_password` varchar(50) DEFAULT NULL,
  `level_id` int(11) DEFAULT NULL,
  `user_isadmin` tinyint(1) DEFAULT '0',
  `user_altemails` varchar(200) DEFAULT NULL,
  `user_pic` varchar(75) DEFAULT NULL,
  `user_sms` varchar(20) DEFAULT NULL,
  `user_cansms` tinyint(1) DEFAULT '0',
  `user_lastupdated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `user_name`, `company_id`, `user_email`, `user_phone`, `user_title`, `user_password`, `level_id`, `user_isadmin`, `user_altemails`, `user_pic`, `user_sms`, `user_cansms`, `user_lastupdated`) VALUES
(1, 'admin', 1, 'kenjimagto@gmail.com', '', 'test', 'e10adc3949ba59abbe56e057f20f883e', NULL, 1, NULL, NULL, NULL, 0, '2013-02-26 13:53:01');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
