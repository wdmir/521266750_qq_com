<?php
require './source/class/class_core.php';
$discuz = & discuz_core::instance();
$discuz->init();
if(!$_G['uid']) {
	showmessage('please login!', NULL, array(), array('login' => 1));
}
$email=$_G['member']['email'];
$sid=$_G['member']['session'];
$gender=DB::result_first("SELECT  `gender` FROM  ".DB::table("common_member_profile")." WHERE  `uid` ='{$_G['uid']}' LIMIT 0 , 1");
$color='dushen';


include(template('ddz/ddz3'));
                                    
include(template('common/footer'));
?>