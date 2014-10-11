#!/usr/bin/perl

# doomsdayTk.pl v. 0.3 Y2K-1 March 11
# Petr Sturc (sturc@fzu.cz)

use Tk;

$trials=0;
$sensetrial=0;
srand();

@dayofweek=( ['Sunday','Sun','Nedele','Ne'],
             ['Monday','Mon','Pondeli','Po'],
	     ['Tuesday','Tue','Utery','Ut'],
	     ['Wednesday','Wed','Streda','St'],
             ['Thursday','Thu','Ctvrtek','Ct'],
	     ['Friday','Fri','Patek','Pa'],
	     ['Saturday','Sat','Sobota','So'] );

@message_1=(
            "Stop joking.",
            "Use Monday, Tuesday....",
            "This day I don't know.",
            "Don't pull my leg",
            );
@message_2=(
            "Not bad. But not right.",
            "Wrong. Try again.",
            "Don't guess. Calculate.",
            "Try again. God with you.");

@message_3=(
	     "Excellent",
	     "Very good",
	     "Correct",
	     "Slow. Must practise");
	     


sub RandomDate {
use integer;
my @month=(0,31,28,31,30,31,30,31,31,30,31,30,31);

  $century=rand($to-$from)+$from;
YE:
  $year=rand(100)+0;
  if ($century==15 and $year<83) { goto YE; }
  $year+=$century*100;

  $isleap=($year % 4 )?0:1;
  $month=rand(12)+1;
  if ($month==2) {
    $day=rand(28+$isleap)+1;
  } else {
    $day=rand($month[$month])+1;
  }

  no integer;
  return ($day,$month,$year);
}

sub Doomsday {
use integer;
my ($day,$month,$year)=@_;
my @monthD=(0,31,28,7,4,9,6,11,8,5,10,7,12);
my @centD=(3,2,0,5);
if ($month <= 2) {
 $isleap=($year % 4 )?0:1;
} else {
 $isleap=0;
}

$cent= $year/100;
$yearp=$year-$cent*100;
$yearD=  @centD[($cent-15)%4] +$yearp+$yearp/4 ;
$restD=  $day- $monthD[$month] - $isleap ;
$dayD=( $yearD+$restD ) % 7;
no integer;
return $dayD;
}


sub MyExit {
 	exit;
}


sub ClearStatus {
  $status->configure(-text=>'');
}

sub Status {
my $string=shift;
    $status->configure(-text=>$string);
    $answer->selectionRange('0','end');
    $top->after(2000,\&ClearStatus);
}

sub CheckAnswer {
 my $status;
 my $match=-1;
 my $ans=$answer->get;
 chomp $ans;
 $trial++;

 for ( $i=0;$i<7;$i++) {
   if ( (($dayofweek[$i][0] eq $ans) or ($dayofweek[$i][1] eq $ans)) or 
        (($dayofweek[$i][2] eq $ans) or ($dayofweek[$i][3] eq $ans)) ) {
    $match=$i;
   }
 }
 if ($match<0) {
    Status $message_1[$trial % 4];
        return;
 } else {
   $trial=0;
   $sensetrial++;
 }

 if ($match eq Doomsday(@date)) {
    $diff=time - $starttime;
    if ($diff<=20) {
       $status=$message_3[0];
    } elsif ($diff>20 and $diff<=30) {
       $status=$message_3[1];
    } elsif ($diff>30 and $diff<=60) {
       $status=$message_3[2];
    } else {
      $status=$message_3[3];
    }
    $status.="\. Bye (Time $diff s)";
    Status $status;
    $top->after(1000,\&MyExit);;
 } else {
    Status $message_2[$sensetrial % 4];
 }
}

####### MAIN ########
$from=18;
$to=20;

@date=RandomDate();
$question="Which day of week is $date[0]\.$date[1]\.$date[2]?";
$starttime=time;

$top=MainWindow->new;
$top->Label(-text=>$question)->pack();
$answer=$top->Entry()->pack(-pady=>5);
$status=$top->Label(-text=>'',-relief=>'groove')->pack(-fill=>'x');

$answer->bind('<Return>',\&CheckAnswer);
$answer->focus;

MainLoop;

