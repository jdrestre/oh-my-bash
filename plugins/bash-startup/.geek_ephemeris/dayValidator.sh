#!/bin/bash

# options links to convert images into ascii code 
# https://www.text-image.com/convert/matrix.html
# https://manytools.org/hacker-tools/convert-images-to-ascii-art/
# https://image-to-ascii.xmlformatter.io/

DATE=`date +"%d-%m"`
DAYOFYEAR=`date +%j`
DAYOFWEEK=`date +%u`
DAYOFMONTH=`date +%d`
MONTHNUMBER=`date +%m`

#VALIDATING THAT IT IS DAY 256 OF THE YEAR FOR PROGRAMMER DAY
if test "$DAYOFYEAR" == "256";
then
	PROGRAMERDAY=`date +"%d-%m"`
else
	PROGRAMERDAY="01-01-0001"
fi

#VALIDATING THAT IT IS LAST FRIDAY IN JULY FOR SYSADMIN
if [ $MONTHNUMBER -eq 07 ] && [ $DAYOFWEEK -eq 5 ] && [ $DAYOFMONTH -gt 24 ]
then
	SYSADMINDAY=`date +"%d-%m"`
else
	SYSADMINDAY="01-01-0001"
fi

#VALIDATING THAT IT IS FOURTH SATURDAY IN JUNE FOR SMURF
if [ $MONTHNUMBER -eq 06 ] && [ $DAYOFWEEK -eq 6 ] && [ $DAYOFMONTH -ge 22 ] && [ $DAYOFMONTH -le 28 ]
then
	SMURFDAY=`date +"%d-%m"`
else
	SMURFDAY="01-01-0001"
fi

#CASE TO SEE WHAT DRAWING TO SHOW
case $DATE in
	14-03)
		cat ~/.oh-my-bash/plugins/bash-startup/.geek_ephemeris/welcomePictures/pi2 | lolcat
		echo ""
		echo "Happy Pi π Day!" | lolcat
		echo ""
	;;
	25-03)
		cat ~/.oh-my-bash/plugins/bash-startup/.geek_ephemeris/welcomePictures/gandalf2 | lolcat
		echo ""
		echo "Happy International Tolkien Reading Day!" | lolcat
		echo ""
	;;
	04-05)
		cat ~/.oh-my-bash/plugins/bash-startup/.geek_ephemeris/welcomePictures/starwars | lolcat
		echo ""
		echo "Happy Star Wars day" | lolcat
		echo "May the 4th - May the Force be with you" | lolcat
		echo ""
	;;
	10-05)
		cat ~/.oh-my-bash/plugins/bash-startup/.geek_ephemeris/welcomePictures/garrote | lolcat
		echo ""
		echo "Happy garrote (Stick) day" | lolcat
		echo "For fans of The Simpsons, May 10 has officially become Stick Day, in honor of the classic fourth season episode in which this unsettling celebration takes place."
		;;
	25-05)
		cat ~/.oh-my-bash/plugins/bash-startup/.geek_ephemeris/welcomePictures/friki | lolcat
		echo ""
		echo "Happy Geek Pride Day" | lolcat
		echo ""
		;;
	19-09)
		cat ~/.oh-my-bash/plugins/bash-startup/.geek_ephemeris/welcomePictures/pirata | lolcat
		echo ""
		echo "Happy International Talk Like a Pirate Day!" | lolcat
		echo ""
		;;
	29-08)
		cat ~/.oh-my-bash/plugins/bash-startup/.geek_ephemeris/welcomePictures/joystick | lolcat
		echo ""
		echo "Happy world gamer day" | lolcat
		echo ""
		;;
	18-09)
		cat ~/.oh-my-bash/plugins/bash-startup/.geek_ephemeris/welcomePictures/batman | lolcat
		echo ""
		echo "Happy world batman day" | lolcat
		echo ""
		;;
	28-01)
		cat ~/.oh-my-bash/plugins/bash-startup/.geek_ephemeris/welcomePictures/lego | lolcat
		echo ""
		echo "Happy world lego day" | lolcat
		echo ""
		;;
	09-05)
		cat ~/.oh-my-bash/plugins/bash-startup/.geek_ephemeris/welcomePictures/goku2 | lolcat
		echo ""
		echo "Happy goku day" | lolcat
		echo ""
		;;
	$PROGRAMERDAY)
		cat ~/.oh-my-bash/plugins/bash-startup/.geek_ephemeris/welcomePictures/programerday | lolcat
		echo ""
		echo "Happy programmer's day" | lolcat
		echo ""
		;;
	$SYSADMINDAY)
		cat ~/.oh-my-bash/plugins/bash-startup/.geek_ephemeris/welcomePictures/sysadminday | lolcat
		echo ""
		echo "Happy sysadmin day"
		echo ""
		;;
	$SMURFDAY)
		cat ~/.oh-my-bash/plugins/bash-startup/.geek_ephemeris/welcomePictures/smurf.ans
		echo ""
		echo "World Smurfs Day" | lolcat
		echo "This event was created in 2011 in homage to the creator of the Smurfs, the Belgian cartoonist Pierre Culliford, better known as "Peyo" (1928-1992), born on 06/25/1928."
		;;
	24-05)
		echo ""
		cat ~/.oh-my-bash/plugins/bash-startup/.geek_ephemeris/welcomePictures/mariaAuxiliadora.txt | lolcat
		echo 'Happy day of Mary Help of Christians' | lolcat
		echo "The tradition of this advocation goes back to 1571, when  the whole of Christendom was saved by Mary Help of Christians when Catholics throughout Europe prayed the Rosary."
		;;
	03-06)
		cat ~/.oh-my-bash/plugins/bash-startup/.geek_ephemeris/welcomePictures/bike.txt | lolcat
		echo ""
		echo 'Happy bicycle day' | lolcat
		echo "The General Assembly of the United Nations (UN) established June 3 as World Bicycle Day each year. This commemoration has been held since 2018 and seeks to promote the use of this means of transport to take care of the environment and reduce its pollution."
		;;
	14-04)
		cat ~/.oh-my-bash/plugins/bash-startup/.geek_ephemeris/welcomePictures/goalkepper.txt | lolcat
		echo ""
		echo 'Happy soccer goalkeeper day' | lolcat
		echo "It has been celebrated since 2013, Miguel Calero's birthday"
	;;
	21-10)
		cat ~/.oh-my-bash/plugins/bash-startup/.geek_ephemeris/welcomePictures/backToTheFuture | lolcat
		echo ""
		echo 'Back to the Future Day' | lolcat
		echo "It’s a day honoring the fictional story of Marty McFly and his companion,  Doc’s, time travel back to October 21, 2015 in 'Back to the Future II,' the sequel to the original 1985 film, 'Back to the Future.'"
	;;
	05-06)
		cat ~/.oh-my-bash/plugins/bash-startup/.geek_ephemeris/welcomePictures/worldEnvironment | lolcat
		echo ""
		echo 'World Environment Day' | lolcat
		echo "Led by the United Nations Environment Program (UNEP) and celebrated every June 5 since 1973, World Environment Day is the largest global platform for environmental outreach and is celebrated by millions of people around the world."
	;;
	04-01)
		cat ~/.oh-my-bash/plugins/bash-startup/.geek_ephemeris/welcomePictures/braille.txt | lolcat
		echo ""
		echo 'World Braille Day' | lolcat
		echo "Braille is a tactile representation of alphabetic and numerical symbols using six dots to represent each letter and number, and even musical, mathematical and scientific symbols. Braille (named after its inventor in 19th century France, Louis Braille) is used by blind and partially sighted people to read the same books and periodicals as those printed in a visual font."
	;;
	21-06)
		cat ~/.oh-my-bash/plugins/bash-startup/.geek_ephemeris/welcomePictures/yoga.txt | lolcat
		echo ""
		echo 'International Day of Yoga' | lolcat
		echo "Yoga is an ancient physical, mental and spiritual practice that originated in India. The word ‘yoga’ derives from Sanskrit and means to join or to unite, symbolizing the union of body and consciousness."
	;;
	14-06)
		cat ~/.oh-my-bash/plugins/bash-startup/.geek_ephemeris/welcomePictures/blood.txt | lolcat
		echo ""
		echo 'World Blood Donor Day (WBDD)' | lolcat
		echo "The event serves to raise awareness of the need for safe blood and blood products and to thank voluntary, unpaid blood donors for their life-saving gifts of blood."
	;;
	18-06)
		cat ~/.oh-my-bash/plugins/bash-startup/.geek_ephemeris/welcomePictures/sustainableGastronomy.txt | lolcat
		echo ""
		echo 'Sustainable Gastronomy Day' | lolcat
		echo "Sustainable gastronomy, therefore, means cuisine that takes into account where the ingredients are from, how the food is grown and how it gets to our markets and eventually to our plates."
	;;
	30-06)
		cat ~/.oh-my-bash/plugins/bash-startup/.geek_ephemeris/welcomePictures/asteroide.ans
		echo ""
		echo 'International Asteroid Day' | lolcat
		echo "International Asteroid Day aims to raise public awareness about the asteroid impact hazard and to inform the public about the crisis communication actions to be taken at the global level in case of a credible near-Earth object threat."
	;;
	09-06)
		cat ~/.oh-my-bash/plugins/bash-startup/.geek_ephemeris/welcomePictures/donald.ans
		echo ""
		echo 'World Donald Duck Day' | lolcat
		echo "This well-deserved distinction was made in honor of the first appearance of this unique Walt Disney cartoon character, created by Dick Landy on June 9, 1934 in the short film \"The Wise Little Hen\""
	;;
	06-06)
		cat ~/.oh-my-bash/plugins/bash-startup/.geek_ephemeris/welcomePictures/yoyo.txt | lolcat
		echo ""
		echo 'World Yo-Yo day' | lolcat
		echo "This toy was popularized by Donald F. Duncan, choosing the day of his birth (June 6, 1892) for the celebration of this event."
	;;
	21-06)
		cat ~/.oh-my-bash/plugins/bash-startup/.geek_ephemeris/welcomePictures/selfie.txt | lolcat
		echo ""
		echo 'World Selfie day' | lolcat
		echo "In 2014 and after the initiative of DJ Rick McNelly, the organization 'National Selfie Day' was founded on June 21 of that year, in order to raise funds to support different charitable causes. In 2015, "selfie" would become the word of the year, according to Oxford University Press."
	;;
	21-06)
		cat ~/.oh-my-bash/plugins/bash-startup/.geek_ephemeris/welcomePictures/skate.txt | lolcat
		echo ""
		echo 'World Skateboarding Day' | lolcat
		echo "This event was proposed in 2004 by the International Association of Skateboard Companies (IASC), with the aim of promoting the hobby of this sport throughout the world, which has more than 40 million skaters, according to data estimated by the American Sports Data."
	;;
	22-07)
		cat ~/.oh-my-bash/plugins/bash-startup/.geek_ephemeris/welcomePictures/hamaca.txt | lolcat
		echo ""
		echo 'World "Hamaca" Day' | lolcat
		echo ""
	;;
	13-01)
		cat ~/.oh-my-bash/plugins/bash-startup/.geek_ephemeris/welcomePictures/drepressionFight.txt | lolcat
		echo ""
		echo 'World day to fight depression' | lolcat
		echo "Depression (major depressive disorder) is a common and serious medical illness that negatively affects how you feel, the way you think and how you act. Fortunately, it is also treatable. Depression causes feelings of sadness and/or a loss of interest in activities you once enjoyed. It can lead to a variety of emotional and physical problems and can decrease your ability to function at work and at home."
	;;
	10-10)
		cat ~/.oh-my-bash/plugins/bash-startup/.geek_ephemeris/welcomePictures/mentalhealtyday.txt | lolcat
		echo ""
		echo "World Mental Health Day" | lolcat
		echo "		World Mental Health Day is on October 10 and as our understanding of mental health grows, 
		we grow along with it. Mental health has come a long way since the early nineties when the 
		World Federation of Mental Health (WFMH) officially established the day. Our self-awareness and 
		sensitivity towards it have changed things for the better. Our language surrounding mental health 
		has improved as words like “crazy” and “lunatic” are used less flippantly and we come to better 
		understand that they can be unintentionally hurtful and stigmatizing. While we’ve learned a lot, 
		there’s still so much more we can do to evolve as a society."
	;;
	23-04)
		cat ~/.oh-my-bash/plugins/bash-startup/.geek_ephemeris/welcomePictures/diadelidioma.txt | lolcat
		echo ""
		echo "Día del idioma español (Ññ)" | lolcat
		echo "		El Día del Idioma Español en las Naciones Unidas se celebra anualmente el 23 de abril desde 2010. Fue establecido por el Departamento de Información Pública de la ONU para concienciar al personal de la Organización y al mundo en general acerca de la historia, la cultura y el uso del español como idioma oficial"
	;;
	16-12|17-12|18-12|19-12|20-12|21-12|22-12|23-12|24-12)
		cat ~/.oh-my-bash/plugins/bash-startup/.geek_ephemeris/welcomePictures/pesebre24dic 
        echo "" 
		DAY_OF_NOVENA=$(($DAYOFMONTH - 15))
		echo "Día $DAY_OF_NOVENA Novena Niño Dios" 
	    echo ""
	;;
	*)
		cat ~/.oh-my-bash/plugins/bash-startup/.geek_ephemeris/welcomePictures/submarine | lolcat
		echo "It's a new day, I claim a new sun for myself. All systems online." | lolcat
		echo ""
esac
