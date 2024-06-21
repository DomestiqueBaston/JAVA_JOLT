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

	Clic ! (la lumière s’allume). Rowena entre dans la cuisine et referme la porte de la chambre (la salle de bain était de l’autre côté de la chambre, donc). Elle se dirige vers la cafetière et pose une main dessus avant de diriger l’autre vers le placard du dessus légèrement sur la droite. Elle l’ouvre et va saisir le… HORREUR ! Il n’y a plus de café. Il lui en faut absolument ! Il ne lui reste plus que 15 (ou jusqu’à 30, on verra plus tard) minutes avant de partir au boulot.

Le chrono se lance !


Là prend place le jeu.


Fin (séquence prévue en animation) ! /!\ Il faudra prendre garde à ce que Rowena soit loin des bords de l’écran pour l’animation où elle attrape son téléphone en la faisant se déplacer avant si besoin car il est sur le comptoir de la cuisine (peu importe où, on ne le voit pas le reste du jeu).


« Dialogue » de la séquence finale, quand le téléphone sonne et que Rowena répond.

Le téléphone sonne… (Phone_Ring – AudioStreamPlayer2D – dans la scène Rowena.tscn qui est en mode « loop »)

Rowena : Uh -oh! That smells like disaster…

Là commence l’animation Phone_Call dans la scène Rowena.tscn où elle attrape son téléphone et la sonnerie du téléphone se coupe à la frame 21 de l’animation).

Elle répond à son téléphone. On freeze l’animation à la frame 30.

Rowena : Hello ?

Boss : Rowena ? Are you kidding me ? Do you even grasp the colossal clusterfuck you've unleashed ? Clients are on the brink of losing their shit, deadlines are being pulverized, and Zeus knows what you're doing ! I can't keep mopping up after your mind-numbing incompetence. It's beyond comprehension, you've hit a new low of ineptitude ! You've single-handedly torpedoed everything ! You are so expendable, Rowena ! Let's skip the pleasantries: You're goddamn fired ! Don't even think about showing your face here ever again ! You're done ! Finished !

Sonnerie de fin de communication. On relance l’animation à la frame 31 et on joue le son Hang_Up de la scène Rowena.tscn à partir de la frame 35.

Elle lâche son téléphone qui tombe par terre.

Rowena : (Wait_Base animation)That's it then... (Nonsense animation) Well. Back to bed. (Walk animation to the right until Rowena’s out of the field)

As soon as Rowena’s out, we play the OUTRO.tscn.
Ce que Rowena peut essayer de faire (ou pas)...


	Dans tous les cas, elle finira par faire repasser le café de la veille qu’elle a mis à la poubelle, en ayant pris soin de s’en servir une tasse et de le boire avant de tout recracher tellement c’est dégueulasse. Si le joueur essaye de faire cela avant 9h14, systématiquement Rowena se dira « Non, je ne peux pas faire ça ! ». C’est seulement à partir de 9h14 (?) qu’elle regardera l’horloge et se dira « Bon, tant pis, plus le choix ! » et lancera les opérations. Alors à ce moment-là, la partie sera bien entendu perdue puisqu’elle renoncera à tout et retournera se coucher ! Elle sortira par où elle est entrée au départ et refermera la porte (son).

	On devra garder à l’esprit que Rowena n’a que 2 mains et pas de poche puisqu’elle sort de la douche en serviette de toilette. Cela signifie qu’il ne sera pas possible de se balader avec plus de deux objets en mains. Si les objets sont petits, on pourra moduler cette limite. Par exemple : tous les grains de café qu’elle ramassera pourront tenir dans une main, il en deviendront éventuellement instantanément un seul.

	Si le joueur veut prendre plusieurs exemplaires d’un objet dont il n’aura pas besoin (en plusieurs exemplaires), Rowena aura des répliques du genre « One will be more than enough! », « No, I'm not starting a collection! »

	Si Rowena essaye d’utiliser un objet avec un autre mais que cela ne sert à rien, elle dira « Nonsense! » ou « Hm... Nope! » ou « That won't stick. » ou « Hmm... doesn't ring any bells. » ou « Sorry, doesn't click. » 
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
	Elle réutilisera son torchon (l’autre, le grand est trop « dégueu »).
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
	Elle videra ensuite ce verre d’eau dans le réservoir de la cafetière.
	Rowena refusera de fouiller dans la poubelle tant qu’il ne sera pas au moins 9h10 (on réglera ce délai plus tard).
	Une fois l’heure atteinte, à ce moment-là, n’ayant plus trop le choix, Rowena acceptera de fouiller dans la poubelle sous l’évier pour récupérer le filtre à café plein de la veille. Le replacera dans la cafetière pour le repasser. Allumera la cafetière.
	Quand le café sera passé, elle prendra la tasse rouge devant les couteaux de cuisine (à droite de la bouteille de lait sur le plan de travail) et pas celle à côté de la cafetière car elle est ébréchée. Se servira une tasse de café et la boira… pour la recracher aussitôt !

Ce que Rowena peut dire de certaines choses qu’elle va prendre ou pas, etc.


	Couteau, fourchette, cuillère (couverts) dans le tiroir sous le toaster : « Ok ! I’ll take only one. » Ou « One’s more than enough. » quand Rowena en a déjà un/une.

	Les couteaux (couverts) : Quand Rowena voudra les utiliser elle dira « Awake as I am, I'm going to hurt myself. » Sauf pour la deuxième tentative pour couper un filtre.
	Assiette, bol, etc. : « I'm not going to walk around with this, or am I? Well… »

	Les grosses casseroles, Cocotte, etc. : « There's no way I'm dragging that around . »
	
	Les placards au dessus de la hotte/micro-onde et du frigo : « Naaa! Too high, I've never put anything in it. »

	Dans le four : « I'd have to clean it, it's so gross (and empty). »

	Dans le tiroir sous le four : « It’s filled with burnt pizza remains... »

	Placard de gauche de la hotte/micro-onde : « Glasses and plates. »

	Tiroir à droite de la gazinière : « It's where I store useless stuff like a garlic press. »

	Un presse-ail dans le tiroir d’outils de cuisine : « What could I possibly do with it now? »

	Un tire-bouchon dans le tiroir d’outils de cuisine : « Hm... No, too soon. »

	Une chaise : « I'm fine, I've had enough rest so far. »

	Un tabouret : « As soon as I find out what it's for, okay. »

	Un petit torchon : « It's clean, it'll be perfect! »

	Un grand torchon : « Hm… I shouldn’t use it except for… I shouldn’t! »

	La radio : « I can adjust the sound of the game, that's clever! »

	La fenêtre de droite : « Ok ! I’ve had enough of this... » – QUIT THE GAME !

	Le toaster : « It works and I can use it whenever I want. »

	les pots d’épices et condiments devant le pot en terre : « At this hour? In my worst nightmares! »

	La cafetière : « It's hopelessly empty. I could cry... If I had time. Besides, the filter holder is stuck.»

	Le robinet : « Yeah. And? » (on ne l’utilise que si on l’associe à quelque chose d’utile pour le jeu)
	La cafetière à droite de l’évier : « It’s at the right place ! » (on ne l’utilise que combinée avec les bons objets)

	Le pot de cookies à droite de la cafetière : « Only one but I need a coffee first. »

	L’huile d’olive devant les cookies : « Ok but that’s to please you. »

	Le pot riz à droite du pot de cookies : « No, it’s raw. »

	Le sel devant le riz : « I’ll never use it with my coffee but ok. »

	Le poivre à gauche du sel : « You always need some pepper ! »

	L’interstice entre le placard et le lave-vaisselle à gauche : « Huh? What would I... Wow! »

	Les premiers grains de café : « Well, that's something... »

	Les seconds grains de café : « My precious! »

	Le pot en terre à gauche du toaster : « Full of raw rice and... Oh, miracle, coffee beans!  Not enough, but I'll take them. »
	Quand Rowena aura assez de grains de café, alors sa réplique sera : « That should be enough. »
	
	Le pot en verre à droite de la cafetière : « Full of raw pasta. »

	La tasse rouge à droite de la cafetière : « No, I chipped it yesterday. »

	La tasse rouge à droite de la bouteille de lait : « Yeah, it's new and clean. »

	Le journal devant la bouteille de lait : « Yesterday's newspaper. »

	Les couteaux de cuisine dans le porte-couteaux : « Naa ! My boss isn't worth the trouble! »

	La bouilloire : « There's still water in it. It's cold. »

	La panier de pommes à gauche du lait : « Apples are ripe, but it's coffee that I need. »

	Le yucca à droite du frigo : « I'll be gardening this weekend. But okay, I’ll take it. »

	La casserolle (sauce pan) à droite du Yucca sur la gazinière : « No, there’s still sauce in it. »

	La bouilloire derrière la casserolle sur la gazinière : « If you say so... »

	La cocotte (pressure cooker) sur la gazinière : « Ha ! Nope... »

	Le panier de fruits juste à droite de la gazinière : « Just a red apple, nothing more. »

	Le robot-mixer à gauche de la mandoline : « It’s not a Rank Xerox, no way. »

	La mandoline à droite du robot-mixer : « As long as I don’t slice my fingers off. »

	La hotte/micro-onde : « It works... If I turn it on. »

	La pizza dans le micro-onde : « It’s now rock hard ! »

	Les placards en hauteur : « In here, I store plates, glasses, bowls, etc. »

	Les tupperwares à gauche de l’évier : « I know how to make them fart. I’ll take one. »

	La planche à découper : « Clever ! As soon as I know what to do with it. »

	La bouteille de lait devant la planche à découper : « Only sour milk. »

	Le réfrigérateur/congélateur : « Yes, way too big for my needs. »

	Le beurrier dans le réfrigérateur : « Butter. There's a little knife in it. »

	Le couteau à beurre : « Ok. I’ll take that. »

	Le machin à eau froide et glaçons dans la porte du réfrigérateur/congélateur : « I hate this thing. But it works. »
	Le tableau au dessus de la chaise : « A painting entitled “Monsieur le marquis et Madame”. »

	Les interrupteurs : « I’m no Hubert Bonisseur de la Bath... » (on n’y touche donc pas !)

	L’évier : « It's made of aluminium and I hate that. There are two plates in it. »

	L’assiette dans l’évier : « It's dirty from yesterday's disgusting pizza. »

	Les fenêtres : « A window. It allows light to enter while maintaining a constant temperature in the apartment. »

	La petite casserole sur le four : « Good. Since we must... »

	Une cuillère en bois : « It was my childhood dream to have one, so I'm taking it. »

	Un verre : « Well... Ok. »

	Un filtre à café : « This could be a first step. »

	Le rouleau de scotch : « Could be useful. »

	La poubelle sous l’évier : Lorsque Roxena veut fouiller la poubelle mais qu’il n’est pas encore temps pour elle de le faire, alors elle dit « Yes, when I was a kid, I used to love playing in the dump. When I was a kid... ». Quand il est enfin temps pour elle, alors elle dit « Ok. Not much of a choice, now. Let's get that yesterday's coffee... »
Ce que Rowena dira lorsque le joueur la fera combiner les bons objets ensemble.


Première tentative :

	Le couteau à beurre et la cafetière : « Yes, I can remove the filter holder without breaking it. »

	Le petit torchon et le porte filtre de la cafetière : « It works, but I can't get enough coffee out of it. »

	Le petit torchon et le lait : « It should be more absorbent now. »

– Rowena lêche le torchon : « Let’s taste it ! Erk ! » Une fois fait, on enchaîne sur le deuxième dialogue.



Deuxième tentative :

	La cuillère en bois et les grains de café (tous): « Ok. Well, that's something. »

	En rajoutant le torchon dessus : « Looks like we have a lead here... »

	Et en finissant avec la cuillère en bois : « Got it ! » Elle obtient du café moulu.

– « One small step for man, one giant leap for mankind. »

	La plache à découper et un filtre à café : « Alright ! »

	Puis avec le couteau de cuisine : « Okay. But just this once. » Elle obtient un morceau de filtre.

	Le morceau de filtre et le café moulu : « Yes. And ? »

	Le « patch » et le scotch : « Ok, it’s now sealed. »

– Rowena se met le patch sur le bras avec du scotch. Attend 10 secondes (en jeu). « Darn! This thing does absolutely nothing for me. »

	Le patch et le robinet : « Yeah, that should make it porous... »

–  Rowena se remet le patch sur le bras. Attends encore 10 secondes (en jeu). « Damn it, this stupid thing doesn't work at all! » Une fois fait, on enchaîne sur le troisième dialogue.


Troisième tentative :

	Un verre et le robinet : « Okay, but I won't drink it: I don't really like the taste. »

	Un verre d’eau et la cafetière : « Considering that I don't have spare hours, a glass of water will suffice. »

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
	Pour les interactions entre les objets (de l’inventaire) et le robinet (par exemple), il faudra sélectionner l’objet dans l’inventaire, le curseur passera à Cross_Active, on sortira de la fenêtre de l’inventaire (en faisant sortir la souris du cadre de l’inventaire (on par sur cette option de sortie) puis on cliquera sur le robinet. S’il doit y avoir un changement, l’élément de l’inventaire changera de nom et on aura éventuellement un commentaire de Rowena sinon, un commentaire de Rowena qui dira que ça ne va pas.


L’inventaire :

	Il prendra (probablement) la forme de la zone de dialogue.
	Il sera assez succinct puisque Rowena ne peut transporter que 2 objets (à moins qu’ils ne soient petits et ou que plusieurs puissent être réunis en 1 objet dans une main comme par exemple des grains de café).
	On portera ainsi l’inventaire à 4 objets s’ils sont petits.
	Il sera possible de regarder les objets (curseur œil).
	On pourra combiner les objets (dans l’inventaire).
	Il sera possible de « jeter » un objet (curseur poubelle (?) à condition qu’il ne soit pas unique ou à considérer que cela signifie ranger, remettre à sa place, etc. sans que le personnage n’ait à le faire, ce qui serait chiant, il faut le reconnaître).
	Les objets composant l’inventaire se trouverons sous forme de texte car la résolution du jeu est trop basse pour des images lisibles (sans compter qu’il faudrait avoir aussi le shader Kuwahara dessus).
	
	Interactions avec les éléments de l’inventaire :
	Elles se feront dans l’espace inventaire (!) de la même manière que dans le décor donc avec le curseur qui change d’aspect en fonction de ce qu’il est possible de faire avec les objets contenus dans l’inventaire. Pour combiner un élément avec un autre, il faudra en sélectionner un qui passera en rouge et ensuite le second (avec le curseur Cross_Active). S’il doit se passer quelque chose, alors on n’aura plus qu’un nouvel objet dans l’inventaire à la place des deux précédents (sauf éventuelle indication contraire) et tout reprendra une couleur par défaut (et la forme concernant le curseur). Si l’action est impossible/inutile, on aura un commentaire de Rowena.
	S’il faut utiliser un élément de l’inventaire avec un autre du décor, alors il faudra cliquer sur « sortir » de l’inventaire pour le fermer (le curseur gardera sa couleur) puis cliquer sur l’élément du décor. S’il doit se passer quelque chose, alors en fonction de ce qui est prévu… 
	Version alternative (qui a ma préférence malgré le risque de fermer la fenêtre à chaque instant) : Pour sortir de l’inventaire, il suffit de déplacer le curseur à l’extérieur de la fenêtre d’inventaire.

	Interactions avec les éléments dans les tiroirs :
	La zone d’inventaire servira à afficher le contenu des tiroirs puisqu’on ne voit pas ce qu’ils contiennent. Une liste sera donnée du contenu et pour se saisir d’un élément, il faudra cliquer dessus avec l’icône appropriée. Pareil pour toute autre action possible.
Notes de trucs importants que je ne sais pas où mettre.


Les animations :
	Il faudra prendre garde à ce que Rowena soit devant le plan de travail de la cuisine (pas à droite de l’écran ni à gauche) pour jouer les animations liées à ce qu’elle fait quand elle tourne le dos car ces animations supposent qu’elle fasse des trucs sur le comptoir (plus ou moins).

	/!\ ROWENA avance de 4 pixels par frame quand elle marche ! /!\



Les trucs à régler :
	