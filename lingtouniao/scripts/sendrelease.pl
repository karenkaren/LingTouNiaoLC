#!/usr/bin/perl

use strict;
use warnings;

#in sh
#sendmail -t wupeijing@sifang.com  [enter]
#subject:ddd
#yyy
#yyy
#.



sub sendemailwithtemplate
{
    my @data=@_;
    my $subject="New builds are coming";
    my $content="<p>fir下载：go to http://fir.im/4hlj</p>";
    my $r_mail = join(",",@data);
    printf $r_mail."\n";

    if (-e "/bin/sendEmail") {
        printf("sending from sendEmail\n");
        `sendEmail -f wupeijing\@lingtouniao.com -t $r_mail -s smtp.exmail.qq.com -u $subject -m \"$content\" -xu wupeijing\@lingtouniao.com -xp ny7788414 -o tls=no -o message-content-type=html -o message-charset=utf8`
    } else {
        printf("sending from sendmail\n");
        my $sender="wupeijing\@lingtouniao.com";

        my $MAIL;

        my $cmd="sendmail -t ";



        open($MAIL,"|/usr/sbin/sendmail -t");
        select($MAIL);
        print "To:$r_mail\nFrom:$sender\nSubject:$subject\nContent-Type:text/html\n$content\n";
        close $MAIL;
    }
}

sendemailwithtemplate @ARGV;

