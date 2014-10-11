#!/usr/bin/perl

# FRACTAX - simple fractal drawing utility
# Based on algorithms in book 
#     O.Peitgen: Beauty of Fractals 
# 
# Requires: Perl and Tk module
#

use Tk;
use Tk::BrowseEntry;
use Tk::WinPhoto;

# Nedinuji defualt values
$axiom='';
%rules=(
		'F'=>'F',
		'f'=>'f',
		'+'=>'+',
		'-'=>'-',
		'X'=>'X',
		'Y'=>'Y',
		'['=>'[',
		']'=>']');
$delta='60';
$depth='3';
$length='20';
@xstax=();
@ystax=();
@astax=();
my $_x=500;
my $_y=500;
my $_angle=0;
$xcounter=0;
$ycounter=0;
$stepcounter=0;
$_model="";
$autocenter='1';
@colors=('black','brown','red','green','blue','yellow','orange','magenta','cyan','white');
$_color='blue';


# Kreslim interface

   $top=MainWindow->new;
   $left=$top->Frame->pack(-side=>left,-anchor=>nw,-padx=>5);
   $modf=$left->Frame->pack;
   $model=$modf->BrowseEntry(-label=>'Model:',-browsecmd=>\&SelectModel,-variable=>\$_model)->pack(-side=>left);
   $modf->Button(-text=>'Add',-command=>\&AddModel)->pack(-side=>left);
   $nopt= $left->Frame(-relief=>'groove',-border=>'2')->pack(-side=>top,-pady=>5,-ipadx=>5);
   $opt=$nopt->Frame->pack(-side=>left);
   $opt2=$nopt->Frame->pack(-side=>left);
  
   $cc=$opt2->Canvas(-width=>'15',-height=>'153',-bg=>'white',
                                 -bd=>0,-relief=>'flat')->pack;
   my $__color;

   for ($i=0;$i<10 ;$i++) {
      my $mycolor=$colors[$i];
      $cc->create('rectangle',3,15*$i+3,15,15*$i+16,fill=>$mycolor,-tag=>$mycolor);
      $cc->bind($mycolor,'<1>',sub { $_color=$mycolor;$cc->itemconfigure('all',-outline=>'black');$cc->itemconfigure($mycolor,-outline=>'white');});
      $cc->bind($mycolor,'<3>',sub {$cnv->configure(-bg=>$mycolor);});
    }


   $frm1=$opt->Frame()->pack(-side=>'top',-ipady=>'5'); 
   $frm1->Label(-text=>'Axiom:',-width=>'8')->pack(-side=>'left');
   $frm1->Entry(-textvariable=>\$axiom,-width=>'25')->pack(-side=>'left');

   $frm2=$opt->Frame->pack(-side=>'top',-ipady=>'5');
   $frm2->Label(-text=>'F rule:',-width=>'8')->pack(-side=>'left');
   $frm2->Entry(-textvariable=>\$rules{F},-width=>'25')->pack(-side=>'left');
    
   $frm3=$opt->Frame->pack(-side=>'top',-ipady=>'5');
   $frm3->Label(-text=>'f rule:',-width=>'8')->pack(-side=>'left');
   $frm3->Entry(-textvariable=>\$rules{f},-width=>'25')->pack(-side=>'left');

   $frm4=$opt->Frame->pack(-side=>'top',-ipady=>'5');
   $frm4->Label(-text=>'+ rule:',-width=>'8')->pack(-side=>'left');
   $frm4->Entry(-textvariable=>\$rules{'+'},-width=>'25')->pack(-side=>'left');
      
   $frm5=$opt->Frame->pack(-side=>'top',-ipady=>'5');
   $frm5->Label(-text=>'- rule:',-width=>'8')->pack(-side=>'left');
   $frm5->Entry(-textvariable=>\$rules{'-'},-width=>'25')->pack(-side=>'left');

   $frm6=$opt->Frame->pack(-side=>'top',-ipady=>'5');
   $frm6->Label(-text=>'X rule:',-width=>'8')->pack(-side=>'left');
   $frm6->Entry(-textvariable=>\$rules{'X'},-width=>'25')->pack(-side=>'left');

   $frm7=$opt->Frame->pack(-side=>'top',-ipady=>'5');
   $frm7->Label(-text=>'Y rule:',-width=>'8')->pack(-side=>'left');
   $frm7->Entry(-textvariable=>\$rules{'Y'},-width=>'25')->pack(-side=>'left');

   $frm8=$opt->Frame->pack(-side=>'top',-ipady=>5);
   $sfrm8=$frm8->Frame->pack(-side=>'top');
   $sfrm8->Label(-text=>'Angle:',-width=>'8')->pack(-side=>'left');
   $sfrm8->Entry(-textvariable=>\$delta,-width=>'3')->pack(-side=>'left');
     
   $sfrm8->Label(-text=>'Depth:',-width=>'8')->pack(-side=>'left');
   $sfrm8->Entry(-textvariable=>\$depth,-width=>'3')->pack(-side=>'left');
   $sfrm8->Label(-text=>'Length:',-width=>'8')->pack(-side=>'left');
   $sfrm8->Entry(-textvariable=>\$length,-width=>'3')->pack(-side=>'left');

   $btf=$left->Frame->pack(-side=>top);
   $runbutton=$btf->Button(-command=>\&Run,-text=>'Run',-width=>4)->pack(-side=>'left');
   $nextbutton=$btf->Button(-command=>\&PrevStep,-text=>'<<',-width=>3)->pack(-side=>'left');
   $nextbutton=$btf->Button(-command=>\&NextStep,-text=>'>>',-width=>3)->pack(-side=>'left');
   $clnbutton=$btf->Button(-command=>\&Clean,-text=>'Clean',-width=>4)->pack(-side=>'left');
   $prnbutton=$btf->Button(-command=>\&Print,-text=>'Print',-width=>4)->pack(-side=>'left');
  # $ac=$btf->Checkbutton(-text=>'Autocenter',-variable=>\$autocenter)->pack;

   $cnf=$top->Frame->pack(-expand=>'both',-fill=>'both');
   $cnv=$cnf->Scrolled(Canvas,-scrollbars=>'se',-bg=>'white',
             -bd=>2,-relief=>'sunken',
	     -scrollregion=>['1','1','1000','1000'])
	     ->pack(-expand=>'both',-fill=>'both');

ReadModels();
SelectModel('dum','Koch\'s curve');
$_model='Koch\'s curve';
MainLoop;

sub Print {
my $fn='output.ps';
my $rc=$cnv->Subwidget('scrolled');
my $pt=$top->Toplevel();
my $img = $top->Photo();
my @fmt = grep($_ ne 'Window',$img->formats);
push @fmt,'PS';

  $pt->title('Printing..');
  $fr1=$pt->Frame->pack;
  $fr1->Label(-text=>'Print as:')->pack(-side=>'left');
 my $fmt  = $fr1->Optionmenu(-variable => \$format,
                             -options  => \@fmt,
                             -command  => sub {
                                               my $lfmt=lc $format; 
                                               $fn=~s/(\w+\.)\w+/$1$lfmt/;
                                               $en->update; } 
            )->pack(-side => 'left');

  $fr2=$pt->Frame->pack;
  $fr2->Label(-text=>'Filename:')->pack(-side=>left);
  $en=$fr2->Entry(-textvariable=>\$fn)->pack(-side=>'left');
  $fr2->Button(-text=>'Print',-command=>[\&DoPrint,$pt,$en,$rc])->pack(-side=>left);
}

sub DoPrint {
my ($dummy,$en,$rc)=@_;
$fn=$en->get;
$|=1;
if ($format eq 'PS'){
    $cnv->postscript(-file=>$fn);
} else {
 my $image=$top->Photo(-format=>'Window',-data=>oct($rc->id));
 $image->write($fn,-format=>$format);
}
$dummy->destroy;
}


sub ReadModels {
open MOD,"models.dat" or DefaultModels();
  while (<MOD>) {
    if (/^#(.*)$/) {
      $model->insert('end',$1); 
    }
  }
close MOD;
}

sub SelectModel {
my ($widg,$lfm)=@_;
open MOD,"models.dat" or die "Cannot open file models.dat: $!";
$a=<MOD>;
while ($a !~/$lfm/) {
  $a=<MOD>;
}
$line=<MOD>;chop $line;
$axiom=$line;
$line=<MOD>;chop $line;$rules{F}=$line;
$line=<MOD>;chop $line;$rules{f}=$line;
$line=<MOD>;chop $line;$rules{'+'}=$line;
$line=<MOD>;chop $line;$rules{'-'}=$line;
$line=<MOD>;chop $line;$rules{'X'}=$line;
$line=<MOD>;chop $line;$rules{'Y'}=$line;
$line=<MOD>;chop $line;$delta=$line;
close MOD;
}


sub DefaultModels {
open MOD,">models.dat" or die "Cannot open file models.dat for writing: $!\n";
  while (<DATA>) {
    print MOD $_;
    if (/^#(.*)$/) {
      $model->insert('end',$1); 
    }
  }
close MOD;
print "Default models copied to file models.dat\n";
}

sub AddModel {
open MOD, ">>models.dat" or die;
print MOD "#$_model\n$axiom\n";
print MOD $rules{'F'},"\n",$rules{'f'},"\n",$rules{'+'},"\n",$rules{'-'},"\n";
print MOD $rules{'X'},"\n",$rules{'Y'},"\n",$delta,"\n";
close MOD;
$model->insert('end',$_model);
}

sub ShowXY {
   my ($w,$x,$y)=@_;
   my $cx=$cnv->canvasx($x-$cnf->x);
    my $cy=$cnv->canvasy($y-$cnf->y);
  $xcoor->configure(-text=>"$cx $cy");
 }


sub Move {
  my $length=shift;
  my ($dx,$dy)=(0,0);

    $dx=$length*cos(3.14159256*$_angle/180.0);
    $dy=$length*sin(3.14159256*$_angle/180.0);
 
  $_x=$_x+$dx;
  $_y=$_y+$dy;
  $xcounter+=$_x;
  $ycounter+=$_y;
  $stepcounter++;
}

sub Forward {
  my $length=shift;
  my ($dx,$dy)=(0,0);

    $dx=$length*cos(3.14159256*$_angle/180.0);
    $dy=$length*sin(3.14159256*$_angle/180.0);
  $cnv->createLine($_x,$_y,$_x+$dx,$_y+$dy,-fill=>$_color);
  $_x=$_x+$dx;
  $_y=$_y+$dy;
  $xcounter+=$_x;
  $ycounter+=$_y;
  $stepcounter++;
  $cnv->update;
}

sub Clean {
  $cnv->delete('all');
  $_x=500;
  $_y=500;
  $_angle=0;
  $xcounter=0;
  $ycounter=0;
  $stepcounter=0;
}

sub Run {
my ($i,$j,$c);
my $stop=0;
my $tmpaxiom='';
my $tmp2axiom=$axiom;

$_x=500;
$_y=500;
$_angle=0;

$runbutton->configure(-text=>'STOP',-command=>sub {$stop=1;});

$cnv->xview(moveto=>0.5-($cnv->width)/2000);
$cnv->yview(moveto=>0.5-($cnv->height)/2000);
$|=1;
  for ($i=0;$i<$depth;$i++) {
  #print "Step $i\n";
   for ($j=0;$j<length($tmp2axiom);$j++) {
	  $tmpaxiom.=$rules{substr($tmp2axiom,$j,1)};
   }
  $tmp2axiom=$tmpaxiom;
  $tmpaxiom='';
  }
  
  
  @axi=split//,$tmp2axiom;
  $ld=$length/$depth;

  while ($c=shift @axi and not $stop ) {
    if ($c eq 'F' ) {
	   #print "Forward\n";
       Forward($ld);
	} elsif ($c eq 'f' ) {
	  Move($ld);
	} elsif ($c eq '+') {
	   #print "Turn +\n";
	   $_angle=($_angle+$delta) % 360;
	} elsif ($c eq '-') {
	   #print "Turn -\n";
	   $_angle=($_angle-$delta) % 360;
	} elsif ($c eq '[') {
	    push @xstax,$_x;#print "Pushed x $_x\n";
		push @ystax,$_y;
		push @astax,$_angle;
	} elsif ($c eq ']') {
	    #print "X is $_x ";
		$_x=pop @xstax;#print "Poped x $_x\n";
		$_y=pop @ystax;
		$_angle=pop @astax;
	}
 }
  if ($autocenter) {
     $cnv->xview(moveto=>+(+($xcounter/$stepcounter)-($cnv->width)/2)/1000.0);
     $cnv->yview(moveto=>+(+($ycounter/$stepcounter)-($cnv->height)/2)/1000.0);
  }
 $runbutton->configure(-text=>'Run',-command=>\&Run);
}

sub PrevStep {
if ($depth>1) {
$depth--;}
Clean;
Run;

}

sub NextStep {
$depth++;
Clean;
Run;
}
__END__
#Koch's curve
F--F--F
F+F--F+F
f
+
-
X
Y
60
#Peano's curve
X
F
f
+
-
XFYFX+F+YFXFY-F-XFYFX
YFXFY-F-XFYFX+F+YFXFY
90
#Quadratic Koch
F+F+F+F
F+F-F-FF+F+F-F
f
+
-
X
Y
90
#Hilbert curve
X
F
f
+
-
-YF+XFX+FY-
+XF-YFY-FX+
90
#Sierpinsky gasket
FXF--FF--FF
FF
f
+
-
--FXF++FXF++FXF--
Y
60
#Square Sierpinsky
F+F+F+F
FF+F+F+F+FF
f
+
-
X
Y
90
#Dragon
X
F
f
+
-
X+YF+
-FX-Y
90
#Quadratic Koch II
F+F+F+F
F+F-F-F+F+F-F
f
+
-
X
Y
90
#Triangle
X
F
f
-
+
X+YF+
-FX-Y
90
#Quadratic Koch III
F+F+F+F
F+F-[F-F+F]+F-F
f
+
-
X
Y
90
#Bush
F
F[+F]F[-F]F
f
+
-
X
Y
30
#Bush II
Y
F
f
+
-
X[-FFF][+FFF]FX
YFX[+Y][-Y]
30
#Bush III
F
FF+[+F-F-F]-F[-F+F+F]
f
+
-
X
Y
18
#DNA
X
F
f
-
+
X+YF+
-YX-Y
90

