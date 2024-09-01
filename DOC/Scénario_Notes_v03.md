Java Jolt (ou Amère caféine ?)



	Le jeu sera donc un Point & Click. En anglais ?

	Il racontera l’histoire d’une femme, Rowena Pitifool, une conceptrice rédactrice publicitaire, "toxicomane" accro au café, célibataire par dépit et dépressive qui se lève le matin pour se faire un café avant de pouvoir partir au boulot (à priori, elle aura déjà fait sa toilette donc peut-être aura-t-elle encore une serviette sur la tête et/ou se baladera-t-elle encore enveloppée dans une serviette). Il n’y a plus de café et il va falloir trouver une solution car sans café, pas moyen d’aller plus loin. Il reste 15 minutes en temps réel (à ajuster ultérieurement et très probablement plutôt 30 minutes) pour trouver un moyen de faire un café malgré tout. Passées ces 15 (ou 30) minutes, le téléphone sonnera et en décrochant, son patron lui dira « t’es virée ! »

	Le fait est que de toute manière elle sera virée car elle ne pourra pas se faire de café. Cela signifie donc qu’il s’agit là d’un jeu dans lequel le joueur ne pourra pas gagner à moins de considérer qu’arriver à la fin de l’histoire signifie gagner.

	Dans ce type de jeu, on passe son temps à trouver un moyen (toujours débile) de faire des choses en fouillant partout, combinant des objets incongrus avec d’autres pour en faire un nouveau qui permettra d’accéder à la suite de l’histoire pour recommencer ainsi de suite jusqu’à la fin.


	La première tentative la verra démonter la machine à café pour en lécher les restes de café dans les « tuyaux ».
	La suivante sera de récupérer des vieux grains de café tombés derrière les pots et le meuble pour les moudre et obtenir une poudre afin de s’en faire des patchs.
	La dernière consistera à faire recuire le café de la veille pris dans la poubelle.


	Dans ce jeu il y aura aussi un second personnage avec lequel Rowena va discuter.

	Le docteur F. :
	La présence du Dr. F. dans la tête de Rowena. Il est l’« ami imaginaire » qui se fout d’elle et l’enfonce à chaque fois qu’il le peut en faisant des références plus ou moins bien senties concernant son boulot de merde et sa (non) vie amoureuse/sexuelle.
Un peu plus de détails...


Pendant la scène qui suit on voit le générique du jeu.

Plan fixe de la cuisine. Lumière éteinte.
	Il est 9h (?) et on entend une radio gueuler un flash info à la con pendant quelques secondes avant d’être arrêtée. Puis un long râle de réveille. Rowena Pitifool s’est réveillée. Viennent ensuite des froissements de draps puis des bruits de pas qui s’éloignent un peu et enfin une poignée de porte actionnée. Rowena est entrée dans la salle de bain. Ouvre l’eau. Attrape des trucs, en repose d’autres. Relance une autre radio fin du flash info/musique/whatever. Elle entre dans la douche ce qui fait varier le son de l’eau qui coule… Puis l’eau est coupée. Divers bruits signifiant plus ou moins qu’elle attrape des serviettes pour s’en mettre une sur la tête et une autour du corps (si elle en a deux mais je pense qu’on va faire comme ça). La radio s’arrête. Des bruits de pas qui se rapprochent un peu. A nouveau une poignée de porte.

Fin du générique

	Clic ! (la lumière s’allume). Rowena entre dans la cuisine et referme la porte de la chambre (la salle de bain était de l’autre côté de la chambre, donc). Elle se dirige vers le placard à café légèrement sur la droite. Elle l’ouvre et va saisir le… HORREUR ! Il n’y a plus de café. Il lui en faut absolument ! Il ne lui reste plus que 15 (ou jusqu’à 30, on verra plus tard) minutes avant de partir au boulot.

Le chrono se lance !


Là prend place le jeu.


Fin (séquence prévue en animation) ! /!\ Il faudra prendre garde à ce que Rowena soit loin des bords de l’écran pour l’animation où elle attrape son téléphone en la faisant se déplacer avant si besoin car il est sur le comptoir de la cuisine (peu importe où, on ne le voit pas le reste du jeu).

« Dialogue » de la séquence finale, quand le téléphone sonne et que Rowena répond.

1 seconde après que Rowena ait recraché son café et se soit retournée :

Le téléphone sonne… (Phone_Ring – AudioStreamPlayer2D – dans la scène Rowena.tscn qui est en mode « loop »)

Rowena (Ici, on utilise la boîte des commentaires, pas le setup des dialogues) : Uh -oh! That smells like disaster…

Là commence l’animation Phone_Call dans la scène Rowena.tscn où elle attrape son téléphone et la sonnerie du téléphone se coupe à la frame 21 de l’animation).

Elle répond à son téléphone. On freeze l’animation à la frame 30.

Pour ce dialogue, on utilisera le setup des... dialogues. Les phrases de Rowena auront toujours la même couleur (Rose) et le Boss sera en violet (144, 91, 194). La couleur du Boss sera éventuellement à exporter s’il faut la modifier.

Rowena : Hello ?

Boss : Rowena ? Are you kidding me ? Do you even grasp the colossal clusterfuck you've unleashed ? Clients are on the brink of losing their shit, deadlines are being pulverized, and Zeus knows what you're doing ! I can't keep mopping up after your mind-numbing incompetence. It's beyond comprehension, you've hit a new low of ineptitude !(BREAK avec les « ... », sinon le texte ne rentrera pas dans la fenêtre et on enchaîne automatiquement au bout de 2 secondes si le joueur ne clique pas) You've single-handedly torpedoed everything ! You are so expendable, Rowena ! Let's skip the pleasantries: You're goddamn fired ! Don't even think about showing your face here ever again ! You're done ! Finished !(BREAK avec les « ... », sinon le texte ne rentrera pas dans la fenêtre et on enchaîne automatiquement au bout de 2 secondes si le joueur ne clique pas). Fin du dialogue.

On relance l’animation à la frame 31.

Elle lâche son téléphone qui tombe par terre.

Rowena (Ici, on utilise la boîte des commentaires, pas le setup des dialogues) : (Wait_Base animation)That's it then... (Nonsense animation) Well. Back to bed. (Walk animation to the right until Rowena’s out of the field).

As soon as Rowena’s out, we play the OUTRO.tscn.
Ce que Rowena peut essayer de faire (ou pas)...


	Dans tous les cas, elle finira par faire repasser le café de la veille qu’elle a mis à la poubelle, en ayant pris soin de s’en servir une tasse et de le boire avant de tout recracher tellement c’est dégueulasse. Si le joueur essaye de faire cela avant 9h10, systématiquement Rowena se dira « Non, je ne peux pas faire ça ! ». C’est seulement à partir de 9h10 (?) qu’elle regardera l’horloge et se dira « Bon, tant pis, plus le choix ! » et lancera les opérations. Alors à ce moment-là, la partie sera bien entendu perdue puisqu’elle renoncera à tout et retournera se coucher ! Elle sortira par où elle est entrée au départ et refermera la porte (son).

	On devra garder à l’esprit que Rowena n’a que 2 mains et pas de poche puisqu’elle sort de la douche en serviette de toilette. Cela signifie qu’il ne sera pas possible de se balader avec plus de quatre objets en mains. Si les objets sont petits, on pourra moduler cette limite. Par exemple : tous les grains de café qu’elle ramassera pourront tenir dans une main, il en deviendront éventuellement instantanément un seul.

	Si le joueur veut prendre plusieurs exemplaires d’un objet dont il n’aura pas besoin, Rowena aura ces répliques : « One will be more than enough! » ou « No, I'm not starting a collection! » (aléatoirement).

	Si Rowena essaye d’utiliser un objet avec un autre mais que cela ne sert à rien, elle dira : aléatoirement, « That’s doesn’t ring any bell to me ! », « Maybe some other day», « Yeah, or I could just lick the floor... » ou encore « No way, Jose ! » si on lui demande de combiner des mauvais objets.
Ce que Rowena peut trouver d’utile dans la cuisine pour chaque tentative


On fait court pour la première tentative pour que le joueur choppe l’esprit du scénario.
Là où l’on peut trouver des éléments cachés nécessaires à une autre tentative que celle en cours, on ne trouvera rien pour la tentative en cours. Par exemple des grains de café lors de la première tentative.

1ère tentative : démonter la machine à café pour en lécher les restes de café dans les « tuyaux ».

	Dans le réfrigérateur il y a du beurre dans lequel est planté un couteau à beurre. Il servira à démonter le support du filtre en plastique rouge de la cafetière sans la casser. Tout autre couteau ne fera pas l’affaire !
	À gauche de la fenêtre de droite, contre le mur, il y a un petit torchon que Rowena devra aller passer dans le support à filtre pour essayer de récupérer un peu de café en l’« essuyant ». Ça ne marchera pas. Rowena devra alors un peu humidifier le torchon. Pour cela, Rowena peut utiliser du lait (elle ne le fera pas avec l’eau du robinet dont elle n’aime pas le goût !) qu’elle peut trouver dans la porte du réfrigérateur (sur le plan de travail devant la planche à découper, le lait de la bouteille a tourné et Rowena doit la jeter… demain…). Ensuite, elle pourra récupérer du café en l’essuyant avec le torchon mais finalement, cela fera bien trop peu (en plus du fait que ça n’est pas bon du tout) !
	

2ème tentative : récupérer des vieux grains de café tombés derrière les pots et le meuble pour les moudre et obtenir une poudre afin de s’en faire des patchs.

	Récupérer des grains de café :
	Sur le plan de travail, à côté du pot en terre, derrière le sel, Rowena pourra trouver quelques grains de cafés perdus (il faudra enlever le sel et le poivre pour les trouver). Ça n’est pas suffisant.
	Par terre, entre le lave-vaisselle et le meuble à sa droite, Rowena trouvera encore des grains de café.

	Moudre les vieux grains de café (elle n’a pas de moulin à café) :
	Rowena trouvera une cuillère en bois dans le tiroir du haut du meuble à droite de la gazinière.
	Derrière la bouteille de lait périmé se trouve la planche à découper.
	Elle réutilisera son torchon (l’autre, le grand, est trop « dégueu »).
	Elle placera les grains de café dans le torchon sur la planche à découper, les recouvrira avec l’autre bout du torchon et les écrasera avec la cuillère en bois.

	Se faire un patch au café :
	Il reste des filtres à café dans le tiroir du milieu à gauche de la gazinière.
	Dans le tiroir de droite dans lequel il y a les couverts, un couteau. Avec le couteau elle coupera le filtre à café en deux sur la planche à découper pour n’en garder que la moitié (sinon, c’est trop grand).
	Elle mettra son café moulu dans le demi filtre à café, le repliera et le fermera avec un morceau de scotch qu’elle coupera du rouleau trouvé dans le tiroir du haut à gauche de la gazinière.
	Puis coupera un grand morceau de scotch. Et posera le patch au café sur son bras en le fixant avec son grand morceau de scotch.
	Elle décidera que ça ne marche pas au bout de 30 secondes (5 secondes dans le jeu). Sans doute car il est trop sec. Elle enlèvera le patch.
	Rowena ira humidifier son patch sous le robinet de l’évier.
	Replacera son patch sur son bras (le scotch fonctionnera encore).
	Elle attendra à nouveau 30 secondes (5 secondes en jeu) et décidera que ça ne marche définitivement pas.


3ème tentative : faire recuire le café de la veille pris dans la poubelle.
	Elle ira prendre un verre dans le placard vitré à gauche de la hotte/micro-onde au dessus de la gazinière et le remplira d’eau au robinet.
	Elle videra ensuite ce verre d’eau dans le réservoir de la ².
	Rowena refusera de fouiller dans la poubelle tant qu’il ne sera pas au moins 9h10 (on réglera ce délai plus tard).
	Une fois l’heure atteinte, à ce moment-là, n’ayant plus trop le choix, Rowena acceptera de fouiller dans la poubelle sous l’évier pour récupérer le filtre à café plein de la veille. Le replacera dans la cafetière pour le repasser. Allumera la cafetière.
	Quand le café sera passé, elle prendra la tasse rouge devant les couteaux de cuisine (à droite de la bouteille de lait sur le plan de travail) et pas celle à côté de la cafetière car elle est ébréchée. Se servira une tasse de café et la boira… pour la recracher aussitôt !

Ce que Rowena peut dire de certaines choses qu’elle va prendre ou pas, etc.


/!\ A moins que ce soit précisé autrement, Rowena donnera le nom de ce qu’elle désigne quand elle le regardera. /!\ A ne pas confondre avec son commentaire quand on veut prendre les choses.

Le Coffee Cupboard (quand on l’ouvre) : « I like rubbing salt in the wound ! »
	Canned Green beans : «Not what I had in mind... » (elle ne prend pas)
	Canned Beans : « They know how to make me fart, so... » (elle ne prend pas)
	Empty Coffee Space : « I'd better take ten more looks at it, just in case... »


Le lave-vaisselle : « My dishwasher… » Quand il est ouvert « It’s empty. »

	L’interstice entre le placard et le lave-vaisselle à gauche : « Huh? What would I... Wow! » (ramasse des grains de café). On n’a « accès » à ce collider que pour la 2ème tentative (avant il est inactif). Quand Rowena aura assez de grains de café, alors sa réplique sera : « That should be enough. »

Le four : « My oven… » Quand il est ouvert «It's as empty as space is ! »

	Dans le four (3 empty spaces) : « I'd have to clean it, it's so gross. » (elle ne prend pas)

	Dans le tiroir sous le four : « It’s filled with burnt pizza remains... » quand on regarde le collider quand il est ouvert (elle ne prend pas)

Cuttlery drawer : « That’s a nice Cuttlery drawer, isn’t it ? »

	Couteau, fourchette, cuillère (couverts) dans le tiroir sous le toaster : « Ok ! I’ll take one. » Ou « One’s more than enough. » quand Rowena en a déjà un/une.

	Les couteaux (couverts) : Quand Rowena voudra les utiliser elle dira « Awake as I am, I'm going to hurt myself. » Sauf pour la deuxième tentative pour couper un filtre.
	
Les placards au dessus de la hotte/micro-onde et du frigo : « Naaa! Too high, I've never put anything in it. »

Left Glass Cupboard : « Glasses and plates. » (verres et assiettes)

Kitchen Tool drawer : « Here I store useless stuff like a garlic press. »

	Un garlic press dans le tiroir d’outils de cuisine : « What could I possibly do with it now? » (elle ne prend pas)

	Un corkscrew dans le tiroir d’outils de cuisine : « Hm... No, too soon. » (elle ne prend pas)

	Une wooden spoon : « It was my childhood dream to have one. I'm taking it. »

Sur la gazinière :

	La casserolle (sauce pan) à droite du Yucca sur la gazinière : « No, there’s still sauce in it. » (elle ne prend pas)

	La kettle derrière la casserolle sur la gazinière : « If you say so... »

	La cocotte (pressure cooker) sur la gazinière : « There's no way I'm dragging that around. » (elle ne prend pas)

Sur le plan de travail :

	Le panier de fruits juste à droite de la gazinière : « Just a red apple, nothing more. »

	Le robot-mixer à gauche de la mandoline : « It’s not a Rank Xerox, no way. » (elle ne prend pas)

	La mandoline à droite du robot-mixer : « As long as I don’t slice my fingers off. »

	La radio : « I can adjust the sound, that's clever! » (elle ne prend pas)

	Le toaster : « It works and I can use it anytime. » (elle ne prend pas)

	La cafetière : « It's empty. I could cry. The filter holder’s stuck.» (elle ne prend pas sauf le filter holder, bien entendu)

	Le coffee pot (uniquement un cache, on ne peut pas vraiment le prendre. Pour y accéder, on utilisera la cafetière complète, comme pour le filter holder) : « Ok ! I think it’s ready. » (troisième tentative)

	Le robinet : « Yes. And? » (on ne l’utilise que si on l’associe à quelque chose d’utile pour le jeu) (elle ne prend pas)

	Le pot de cookies à droite de la cafetière : « Only one but I need my coffee first. » (elle ne prend pas le pot, juste un cookie)

	L’huile d’olive devant les cookies : « Ok but that’s to please you. »

	Le pot riz à droite du pot de cookies : « No, it’s raw. » (elle ne prend pas)

	Le sel devant le riz : « I’ll never use it with my coffee but ok. »

	Le poivre à gauche du sel : « You always need some pepper ! »

	Les premiers grains de café : « Well, that's something... »

	Les grains de café (par terre entre le lave vaisselle et le placard) : « Oh ! My precious ! »

	Le pot en terre à gauche du toaster : « Full of rice... » Si Rowena a déjà enlevé le sel, elle dira : « Miracle, coffee beans right beside ! »

	Les grains de café à côté du pot de riz en terre : « Zeus almighty! I'll take them. »
	Quand Rowena aura assez de grains de café (quand elle trouvera la «deuxième dose » de grains de café, quelle qu’elle soit, par terre ou à côté du riz derrière le sel, alors sa réplique sera : « That should be enough. »
	
	Le pot en verre à droite de la cafetière : « Full of raw pasta. » (elle ne prend pas)

	La tasse rouge à droite de la cafetière : « No, I chipped it yesterday. »

	La tasse rouge à droite de la bouteille de lait : « Yeah, it's new and clean. »

	La tasse marron : « That’s not my cup of tea. » (elle ne prend pas)

	Le journal devant la bouteille de lait : « Yesterday's newspaper. » (je ne retrouve pas son collider, peut-être n’en a-t-il pas)

	Les couteaux de cuisine dans le porte-couteaux : « Naa ! My boss isn't worth the trouble! »

	La bouilloire : « There's still water in it. It's cold. » (elle ne prend pas)

	Le yucca à droite du frigo : « I'll be gardening this later. But I’ll take it. »

	Les tupperwares à gauche de l’évier : « I know how to make them fart. I’ll take one. »

	La planche à découper : « Clever ! Probably… » (elle prend !)

	La bouteille de lait devant la planche à découper : « Only sour milk. » (elle ne prend pas)

Ailleurs dans la cuisine :

	La fenêtre au dessus de l’évier : « I know what this is : a window. » (elle ne prend pas)

	Une chaise : « I'm fine, I've had enough rest so far. » (elle ne prend pas)

	Un tabouret : « As soon as I find out what it's for. » (elle ne prend pas)

	Un petit torchon à côté de la fenêtre de droite : « It's clean, it'll be perfect! »

	Un grand torchon à côté de la fenêtre de droite : « I shouldn’t use it except for… No, I shouldn’t! » (elle ne prend pas)

	La fenêtre de droite : « I’ve had enough of this… Alright ? » – QUIT THE GAME ! (elle ne prend pas)

	Le tableau au dessus de la chaise : « A painting entitled “Monsieur le marquis et Madame”. » (elle ne prend pas)

	Les interrupteurs : « I’m no Hubert Bonisseur de la Bath... » (on n’y touche donc pas !)

La hotte/micro-onde : « It works... If I turn it on. »

	La pizza dans le micro-onde : « It’s now rock hard ! »	

Le réfrigérateur/congélateur : « Yes, way too big for my needs. »

Refrigerator Left : « That’s where frozen food is. »
	
	Water/ice fountain (sur la porte fermée) : « Where in the world have you been so far ? » (elle ne prend pas)

	Tous les tiroirs : « Way too cold at this hour ! » (elle ne prend pas)

Refrigerator Right : « That’s a refrigerator… »

	Le beurrier dans le réfrigérateur : « Butter. There's a little knife in it. » (elle ne prend pas mais… voire en dessous)

	Le couteau à beurre : « Ok. I’ll take only that knife. »

	Smoothie bottles : « I drink it before working out. But Ok, one. »

	Fruit Juice : « I drink it before working out. But one is Ok. »

	Milk bottles : « Ok for one. »

	The sauce pan : « I’ll leave that here. » (elle ne prend pas)

	Cream pots : « Not now. » (elle ne prend pas)

	Yoghurts : « Ok, ok... » (means she takes one)

	Green pepper : « Way too early for that ! » (elle ne prend pas)

	Tomatoes : « Hm… Nope ! » (elle ne prend pas)

	Eggs : « Ok but I need to be extra careful. » (means she takes one)

	Cauliflower : « Not now. » (elle ne prend pas)

	Yellow pepper : « Ok... No. I was kidding. » (elle ne prend pas)

	Fruits : « Don’t you remember ? I need a coffee ! » (elle ne prend pas)
	
Cleaning Closet: « That’s where I store my cleaning stuff. »

	Le « Destop » (Drain Cleaner) : «To make coffee ? » (elle ne prend pas)

	La lessive : « I’ll use it this weekend. » (elle ne prend pas)

	Le grand sceau : « Hm… Nope. » (elle ne prend pas)

 	La balayette dans le petit sceau : « What was my quest, anyway ? » (elle ne prend pas)

	Le petit sceau contenant la balayette : « What could I possibly do with it ? » (elle ne prend pas)

	La serpillère : « It’s fealthy ! » (elle ne prend pas)

Cupboard Upper Center : « I wonder what’s inside... » (c’est son placard à biscuits)

	La boîte de thé du dessus (la 5) : « Coffee, not tea… Or is it? »
	
	Les boîtes de thé du dessous (de 1 à 4) : « It'll come down on me for this… » (elle ne prend pas)

	La petite boîte de cookies : « I shouldn't be having these cookies. » (elle ne prend pas)

	La grande boîte de cookies : «That’s way too much right now. » (elle ne prend pas)

Cupboard Upper Center Left : « A cupboard… » (c’est un placard à verres et assiettes)

	Un petit verre à vin : « eventually, yes. »

	Un grand verre : « Ok. »

	Une assiette à soupe : « Yes, that’s definitely needed ! »

Kitchen Cabinet : « A cabinet… » (il y a des machins pour cuire des trucs à la vapeur)

	La cocotte : « No way I'm dragging that around. » (elle ne prend pas)

	Le Rice cooker : « Please... »  (elle ne prend pas)

Left Glass Cupboard : « Magical ! I can see through the door. » (verres et assiettes)

	Un verre de vin : « Only one is fine with me. »

	Un verre : « as long as I only take one... »

	Une assiette : « Good. »

Private Drawer : « It’s my private drawer... ». Si on veut le fouiller : « Nobody should know what’s inside. »

Les deux tiroirs entre le précédent et le suivant sont vide ! (« A drawer » - « it’s empty »)

Top Left Drawer : « My junk drawer. »

	Un filtre à café : « This could be a first step. »

	Le rouleau de scotch : « Could be useful. »


The Recycling Closet : « That’s the recycling closet ».

	En le fouillant la poubelle : « It’s half full of plastic and paper. » (elle ne prend pas)


Le machin à eau froide et glaçons dans la porte du réfrigérateur/congélateur de gauche : « I hate this thing. But it works. »

Right Glass Cupboard : « Magic ! I see what’s in there. » (assiettes et bols)

	Right Plates : « Nice and clean. »

	Right Large Bowls : « I have smaller ones but ok. »

	Right Bowls : « I have bigger ones but ok. »

Under Sink Cabinet : « Oh my god ! What’s in it ? »

	La poubelle : Lorsque Rowena veut fouiller la poubelle mais qu’il n’est pas encore temps pour elle de le faire, alors elle dit « I used to play in the dump. When I was a kid… ». Quand il est enfin temps pour elle, alors elle dit « Not much choice. Let's get that filthy coffee… »

	La ventouse (Plunger) : « I’ve always liked that tool. »

	Un panier en plastique : « No. Even though it's lightweight.  » (elle ne prend pas)

	L’extincteur : « That's clever! Or is it...? »

Upper Right Cupboard : « Big stuff in here. »

	Les saladier, casserolles, grande cocotte et cocotte en terre : « No way I'm dragging that around. » (elle ne prend pas)
Ce que Rowena dira lorsque le joueur la fera combiner les bons objets ensemble.


Première tentative :

	Le couteau à beurre et la cafetière : « I can remove the filter holder intact. »

	Le petit torchon et le porte filtre de la cafetière : « It works, but I can't get enough coffee. »

	Le petit torchon et le lait : « It should be more absorbent now. »

– Rowena lêche le torchon : « Let’s taste it ! Erk ! » Une fois fait, on enchaîne sur le deuxième dialogue.



Deuxième tentative :

	Le torchon et les grains de café (tous): « Ok. Well, that's something. »

	En rajoutant la cuillère en bois dessus : « Looks like a plan to me ! » Elle obtient du café moulu.

– « One small step for man, one giant leap… »

	La plache à découper et un filtre à café : « Alright ! »

	Puis avec le couteau de cuisine : « Okay. But just this once. » Elle obtient un morceau de filtre.

	Le morceau de filtre et le café moulu : « Yes. And ? »

	Le « patch » et le scotch : « Ok, it’s now sealed. »

– Rowena se met le patch sur le bras avec du scotch. Attend 5 secondes. « Darn! This thing does nothing ! »

	Le patch et le robinet : « Yeah, that should make it porous... »

–  Rowena se remet le patch sur le bras. Attends encore 5 secondes. « Damn it, it doesn't work at all! » Une fois fait, on enchaîne sur le troisième dialogue.


Troisième tentative :

	Un verre et le robinet : « Okay, but I won't drink it. »

	Un verre d’eau et la cafetière : « Given my time cruch, a glass of water will do. »

	Le café de la poubelle et la cafetière: « Don't think, don't think... »

– Rowena allume la cafetière. Au bout de quelques instants, le café est passé.

	La tasse rouge et la cafetière : « By the grace of Zeus! » Rowena boit le café et le recrache quasiment instantanément. Elle dira alors (après s’être retournée) « Ugh ! This is absolutely rancid ! » Et on enchaîne sur la séquence animée finale.

	
La voix intérieure (le docteur F.)


	Il faut introduire ce personnage qui va intervenir entre chaque tentative dans le jeu uniquement au travers des dialogues étant un « ami » imaginaire de Rowena. Elle parle avec lui à voix haute même s’il n’est que dans sa tête à elle. Sa fonction sera de distiller ± quelques indices concernant le jeu en plus de se foutre de la gueule de Rowena et de l’enfoncer (soyons honnêtes, c’est là, surtout, sa fonction).
	Le docteur F. est un écho du psy que consulte Rowena. Il n’est pas forcément très efficace sauf en ce qui concerne sa faculté à lui prendre de l’argent toutes les semaines. Il se prend pour Freud, est très sarcastique, méprisant et ramène tous ses commentaires au fait que Rowena est célibataire et ne baise pas souvent. Dr. F. étant une émanation de l’imagination de Rowena, il ne fait aucun doute qu’elle même est totalement obnubilée par son célibat et son manque de sport en chambre.
	Il faudra introduire le docteur F. juste après que Rowena se soit rendu compte du fait qu’elle n’a plus de café. Un « court » dialogue à choix multiples entre les deux s’instaurera pour les présenter. Avec interactions du joueur et choix de réponse. La première fois, il n’y aura pas vraiment d’implications dans les choix. Ensuite, en fonction des réponses données par le joueur, Rowena obtiendra plus ou moins d’indices (de toute manière, ça ne sera vraiment jamais miraculeux).

Dialogue à choix multiples :
Voir les trois fichiers .dia


L’interface


Les dialogues :
	En fonction des besoins mais pour le moment quand j’écris, tout l’écran sera destiné à afficher les dialogues en surimpression. Il faudra probablement mettre un fond qui assombrira temporairement l’image derrière afin de rendre le texte définitivement lisible.
	Le texte s’affiche caractère après caractère (voir la « démo ») en émettant un petit son à chaque caractère (sauf les espaces).
	Lorsque le texte sera trop long pour la taille de la zone réservée (si cela arrive), alors on utilisera un petit symbole en bas à droite de la zone avec « … » qui clignote invitant le joueur à cliquer pour afficher la suite du texte soit en faisant de la place en faisant remonter le texte d’une ligne pendant que le reste du texte s’affiche.
	Chaque personnage aura une couleur de texte, ce qui évitera d’avoir à noter son nom ou de mettre un portrait (avec la très faible résolution du jeu, il faut économiser l’espace). On peut supposer que ce sera « bleu » pour Dr. F. et « rose » pour Rowena.
	On affiche les entrées de dialogue de chaque personnage les unes après les autres. Donc à la fin de chaque entrée, on aura les « … » qui clignotent pour signifier qu’il faut cliquer pour la suite (et on vide la zone de dialogue avant de passer texte du personnage suivant, bien entendu).


La souris :
	On quitte le jeu en cliquant sur la fenêtre de droite (comme vu précédemment) avec le curseur « Quit ».
	On règle le son sur le poste de radio (voir plus bas)
	L’action par défaut est le clique gauche.
	Le curseur par défaut est la croix.
	On obtient une info sur ce qui est désigné avec un clique droit.
	Si le curseur est posé sur un objet dont on peut obtenir une information ou interagir avec, alors le curseur changera de couleur.
	Si plusieurs actions sont possibles (regarder,  attraper, etc.), alors on fera défiler les options d’action avec la molette de la souris.
	On règle le volume sonore général sur le BUS Master sur le poste de radio de la cuisine (par défaut, le son (et le curseur) sera sur Sound_Up – maximum – et on aura comme autres choix Sound_Down (-8 DB) et No_Sound (-80 DB). Ou alors on fait varier le volume par tranche à chaque fois qu’on clique (0, -2, -4, -8, -16, -40 et -80) et dans ce cas, le point de départ sera Sound_Down (-8 DB). Si on coupe le son, alors il faut cacher le layer Radio_On_Lights_On qui affiche une lumière témoin de mise en marche et ATTENTION, il est animé dans les scènes OUTRO et INTRO (il faudra donc « overide » ces animations).
	Pour les interactions avec les objets, voir le doc à ce sujet (Détail de comment qu’on fait pour faire les choses_v01.odt).


L’inventaire :
	Il prendra la même forme que la zone de dialogue mais au bas de l’écran.
	Il sera assez succinct puisque Rowena ne peut transporter que 4 objets. Elle dira « Hey! I don't have four arms, I'm not Shiva! » si on lui demande d’en porter plus.
	Il sera possible de regarder les objets (curseur Eye).
	Il sera possible de prendre les objets (curseur Hand).
	Il sera possible d’utiliser les objets (curseur Arrow).
	Il sera possible de « jeter » un objet (curseur Trash à condition qu’il ne soit pas unique ou à considérer que cela signifie ranger, remettre à sa place, etc. sans que le personnage n’ait à le faire, ce qui serait chiant, il faut le reconnaître).
	Les objets composant l’inventaire se trouverons sous forme de texte car la résolution du jeu est trop basse pour des images lisibles (sans compter qu’il faudrait avoir aussi le shader Kuwahara dessus).
	Utiliser un élément de l’inventaire le fera passer en surbrillance (rose, comme pour les dialogues de Rowena). Par défaut, la couleur est le blanc. Le désélectionner lui rendra la couleur par défaut.
	Après avoir combiné des éléments de l’inventaire, ce qui en résulte prend la couleur par défaut et n’est pas sélectionné.
	Pour désassembler des éléments « désassemblables » on les utilisera sur eux-mêmes. Ils le sont par défaut mais on va rester logique. Si on avait dû utiliser du sirop et de l’eau par exemple, on imagine bien qu’on n’aurait pas pu les désassembler.
	L’icon de l’inventaire s’affiche en plaçant la souris dans le coin supérieur gauche. Il y a une animation pour affichage de l’icône et une pour la masquer.
	/!\ IMPORTANT : pendant les séquences de dialogue, l’inventaire ne peut pas être affiché (et l’icône ne peut pas apparaître).
	Pour fermer l’inventaire sans y interagir, il suffit de cliquer à nouveau sur l’icône Inv.
	Lorsque l’inventaire est ouvert, l’icône Inv. ne disparaît pas.


	Interactions avec les éléments dans les tiroirs :
	La zone d’inventaire servira à afficher le contenu des tiroirs puisqu’on ne voit pas ce qu’ils contiennent. Une liste sera donnée du contenu et pour se saisir d’un élément, il faudra cliquer dessus avec l’icône appropriée. Pareil pour toute autre action possible si besoin (voire au dessus).

	Sauver/charger une partie :
	Cela se fera n’importe où. Il n’y aura qu’à faire défiler les icônes d’action à la souris avec la molette et de cliquer sur Sauver pour sauver une partie ou Charger pour… charger une partie.

	Changer le volume sonore du jeu :
	Cela ne peut se faire que sur le poste de radio sur la plan de travail à droite (juste à gauche de la fenêtre). On se servira alors de la molette de la souris pour faire défiler les icônes jusqu’à afficher celle d’augmentation ou diminution du volume ou carrément couper le son.

	Quitter le jeu :
	Il suffira de cliquer sur la fenêtre de droite dans la cuisine (le curseur se transformera en Quit quand on passe dessus). À ce moment-là, la fenêtre de dialogue s’ouvrira et affichera ce que Rowena va dire avec un choix pour le joueur « Hmm... Really? 'Cause if I mess this up… » et les choix de réponses seront « Nothing ventured, nothing gained, I'd say… » (oui) et « Actually, I'd rather stay in this misery… » (non).
Notes de trucs importants que je ne sais pas où mettre.


Les animations :
	Il faudra prendre garde à ce que Rowena soit devant le plan de travail de la cuisine (pas à droite de l’écran ni à gauche) pour jouer les animations liées à ce qu’elle fait quand elle tourne le dos car ces animations supposent qu’elle fasse des trucs sur le comptoir (plus ou moins).

	/!\ ROWENA avance de 4 pixels par frame quand elle marche ! /!\
