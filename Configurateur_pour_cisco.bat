@echo off
@echo ***********************************************
@echo ********** Configurateur pour  CISCO **********
@echo ***********************************************

:demande
REM demande nom du fichir à creer
set /p nomfichier=Quel est le nom du ficher de configuration ?

REM ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
:question_menu
REM Menu
@echo.
@echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++
@echo 			Menu
@echo 1 - Configuration de base d'un routeur / commutateur
@echo 2 - Configuration d'interfaces
@echo 3 - Configuration de vlan
@echo 4 - Configuration de trunk
@echo 5 - Configuration OSPF
@echo 6 - Quitter
@echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++
@echo.
set /p selection= Quelle tache souhaitez vous effectuer ?
if /I "%selection%"=="1" (goto question_config)
if /I "%selection%"=="2" (goto question_interface)
if /I "%selection%"=="3" (goto demande_vlan)
if /I "%selection%"=="4" (goto demande_trunk)
if /I "%selection%"=="5" (goto demande_ospf)
if /I "%selection%"=="6" (goto fin) else (goto question_menu)

REM ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
:question_config
REM demande nom de l'hote
set /p nomhote=Comment s'appelle le routeur ou le switch ?
REM demande mot de passe console
set /p mdpconsole=Quel est le mot de passe console ?
REM demande mot de passe connection à distance
set /p mdpdistance=Quel est le mot de passe pour la connexion a distance ?
REM demande cryptage des mots de passe
set /p cryptage=Crypter les mots de passe (oui/non) ?
if /I "%cryptage%"=="oui" (goto question_privilege)
if /I "%cryptage%"=="o" (goto question_privilege)
if /I "%cryptage%"=="y" (goto question_privilege)
if /I "%cryptage%"=="yes" (goto question_privilege)
if /I "%cryptage%"=="non" (goto question_motd)
if /I "%cryptage%"=="no" (goto question_motd)
if /I "%cryptage%"=="n" (goto question_motd)

:question_privilege
REM demande mot de passe execution privilegie
set /p mdpprivilege=Quel est le mot de passe d'execution privilegie ?

:question_motd
REM demande banniere motd
set /p motd=Quel est le message motd a la connection ?

:question_ssh
REM demande activation ssh
set /p sshact=Activer le protocole SSH version 2 (oui/non) ?
if /I "%sshact%"=="oui" (goto oui_ssh)
if /I "%sshact%"=="o" (goto oui_ssh)
if /I "%sshact%"=="y" (goto oui_ssh)
if /I "%sshact%"=="yes" (goto oui_ssh)
if /I "%sshact%"=="non" (goto config)
if /I "%sshact%"=="no" (goto config)
if /I "%sshact%"=="n" (goto config)
:oui_ssh
set /p userssh=Quel est le nom d'utilisateur local ?
set /p mdpssh=Quel est le mot de passe de l'utilisateur local ?

REM --------------------------------------------------------------------

:config
REM ecriture du nom de l'hote dans le fichier
@echo enable >> %nomfichier%.txt
@echo configure terminal >> %nomfichier%.txt
@echo hostname %nomhote% >> %nomfichier%.txt
REM ecriture des mots de passe dans le fichier
@echo line con 0 >> %nomfichier%.txt
@echo password %mdpconsole% >> %nomfichier%.txt
@echo login >> %nomfichier%.txt
@echo exit >> %nomfichier%.txt
@echo line vty 0 4 >> %nomfichier%.txt
@echo password %mdpdistance% >> %nomfichier%.txt
@echo login >> %nomfichier%.txt
@echo exit >> %nomfichier%.txt
REM verification demande cryptage
if /I "%cryptage%"=="oui" (goto cryptage)
if /I "%cryptage%"=="o" (goto cryptage)
if /I "%cryptage%"=="y" (goto cryptage)
if /I "%cryptage%"=="yes" (goto cryptage)
if /I "%cryptage%"=="non" (goto banniere)
if /I "%cryptage%"=="no" (goto banniere)
if /I "%cryptage%"=="n" (goto banniere)

:cryptage
REM cryptage des mots de passe
@echo enable secret %mdpprivilege% >> %nomfichier%.txt
@echo service password-encryption >> %nomfichier%.txt

:banniere
REM banniere motd
@echo banner motd '%motd%' >> %nomfichier%.txt
REM verification demande ssh
if /I "%sshact%"=="oui" (goto ssh)
if /I "%sshact%"=="o" (goto ssh)
if /I "%sshact%"=="y" (goto ssh)
if /I "%sshact%"=="yes" (goto ssh)
if /I "%sshact%"=="non" (goto question_menu)
if /I "%sshact%"=="no" (goto question_menu)
if /I "%sshact%"=="n" (goto question_menu)

:ssh
REM configuration ssh
@echo ip ssh version 2 >> %nomfichier%.txt
@echo crypto key generate rsa >> %nomfichier%.txt
@echo username %userssh% secret %mdpssh% >> %nomfichier%.txt
@echo line vty 0 15  >> %nomfichier%.txt
@echo transport input ssh  >> %nomfichier%.txt
@echo login local  >> %nomfichier%.txt

REM retour menu
goto question_menu

REM ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:question_interface
REM demande de configuration d'interface
set /p confint=Configurer une interface (oui/non) ?
if /I "%confint%"=="oui" (goto oui_interface)
if /I "%confint%"=="o" (goto oui_interface)
if /I "%confint%"=="y" (goto oui_interface)
if /I "%confint%"=="yes" (goto oui_interface)
if /I "%confint%"=="non" (goto question_menu)
if /I "%confint%"=="no" (goto question_menu)
if /I "%confint%"=="n" (goto question_menu)

:oui_interface
set /p nom_interface=Quel est le nom de l'interface (ex : g0/0, f0/0, s0/0/0) ?
set /p description_interface=Quel est la description de l'interface ?
set /p ip_interface=Quel est son adresse ipv4 et son masque de sous reseau ?
set /p def_gateway_interface=Quel est sa passerelle par defaut ?
goto interface

:question_autre_interface
set /p autre_interface= Faut-il configurer une autre interface (oui/non) ?
if /I "%autre_interface%"=="oui" (goto oui_interface)
if /I "%autre_interface%"=="o" (goto oui_interface)
if /I "%autre_interface%"=="y" (goto oui_interface)
if /I "%autre_interface%"=="yes" (goto oui_interface)
if /I "%autre_interface%"=="non" (goto question_menu)
if /I "%autre_interface%"=="no" (goto question_menu)
if /I "%autre_interface%"=="n" (goto question_menu)

REM ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:interface
REM configuration interface
@echo interface %nom_interface%  >> %nomfichier%.txt
@echo description %description_interface%  >> %nomfichier%.txt
@echo ip address %ip_interface%  >> %nomfichier%.txt
@echo no shutdown  >> %nomfichier%.txt
@echo ip default-gateway %def_gateway_interface%  >> %nomfichier%.txt
@echo exit  >> %nomfichier%.txt

REM verification demande autre interface
goto question_autre_interface

REM ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:demande_vlan
REM demande de configuration vlan
set /p demande_vlan= Faut-il configurer un vlan (oui/non/passer) ?
if /I "%demande_vlan%"=="oui" (goto oui_vlan)
if /I "%demande_vlan%"=="o" (goto oui_vlan)
if /I "%demande_vlan%"=="y" (goto oui_vlan)
if /I "%demande_vlan%"=="yes" (goto oui_vlan)
if /I "%demande_vlan%"=="non" (goto affect_vlan)
if /I "%demande_vlan%"=="no" (goto affect_vlan)
if /I "%demande_vlan%"=="n" (goto affect_vlan)
if /I "%demande_vlan%"=="passer" (goto question_menu)
if /I "%demande_vlan%"=="pass" (goto question_menu)
if /I "%demande_vlan%"=="p" (goto question_menu)


:oui_vlan
REM questions vlan
set /p numero_vlan=Quel est le numero du vlan?
set /p nom_vlan=Quel est le nom du vlan ?
@echo vlan %numero_vlan%  >> %nomfichier%.txt
@echo name %nom_vlan%  >> %nomfichier%.txt


:affect_vlan
REM demande d'affectation d'un port a un vlan
set /p inser_port_vlan=Faut-il affecter un port à un vlan (oui/non) ?
if /I "%inser_port_vlan%"=="oui" (goto oui_affect_vlan)
if /I "%inser_port_vlan%"=="o" (goto oui_affect_vlan)
if /I "%inser_port_vlan%"=="y" (goto oui_affect_vlan)
if /I "%inser_port_vlan%"=="yes" (goto oui_affect_vlan)
if /I "%inser_port_vlan%"=="non" (goto demande_vlan)
if /I "%inser_port_vlan%"=="no" (goto demande_vlan)
if /I "%inser_port_vlan%"=="n" (goto demande_vlan)

:oui_affect_vlan
REM affectation d'un port a un vlan
set /p port_vlan=Quel port doit etre affecter au vlan (ex : g0/0, f0/0, s0/0/0)?
set /p numero_vlan_affect=Quel est le numero du vlan auquel le port sera affecter?
@echo interface %port_vlan%  >> %nomfichier%.txt
@echo switchport mode access  >> %nomfichier%.txt
@echo switchport access vlan %numero_vlan_affect%  >> %nomfichier%.txt
@echo exit  >> %nomfichier%.txt
goto demande_vlan

REM ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:demande_trunk
REM demande de configuration vlan
set /p demande_trunk= Faut-il configurer un trunk (oui/non) ?
if /I "%demande_trunk%"=="oui" (goto oui_trunk)
if /I "%demande_trunk%"=="o" (goto oui_trunk)
if /I "%demande_trunk%"=="y" (goto oui_trunk)
if /I "%demande_trunk%"=="yes" (goto oui_trunk)
if /I "%demande_trunk%"=="non" (goto question_menu)
if /I "%demande_trunk%"=="no" (goto question_menu)
if /I "%demande_trunk%"=="n" (goto question_menu)


:oui_trunk
REM questions trunk
set /p numero_int_trunk=Quel est l'interface affecte au trunk (ex : g0/0, f0/0, s0/0/0) ?
set /p trunk_vlan=Quel est le numero du vlan affecte au trunk ?
@echo interface %runk_vlan%  >> %nomfichier%.txt
@echo switchport mode trunk  >> %nomfichier%.txt
@echo switchport trunk native vlan %trunk_vlan%  >> %nomfichier%.txt
@echo switchport trunk allowed vlan %trunk_vlan%  >> %nomfichier%.txt
@echo exit >> %nomfichier%.txt

REM demande autre port trunk
set /p demande_autre_trunk= Faut-il configurer une autre interface dans le trunk (oui/non) ?
if /I "%demande_autre_trunk%"=="oui" (goto oui_trunk)
if /I "%demande_autre_trunk%"=="o" (goto oui_trunk)
if /I "%demande_autre_trunk%"=="y" (goto oui_trunk)
if /I "%demande_autre_trunk%"=="yes" (goto oui_trunk)
if /I "%demande_autre_trunk%"=="non" (goto demande_trunk)
if /I "%demande_autre_trunk%"=="no" (goto demande_trunk)
if /I "%demande_autre_trunk%"=="n" (goto demande_trunk)


REM ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:demande_ospf
REM demande configuration ospf
set /p id_ospf=Quel est l'ID du routeur OSPF ?
@echo router ospf 1 >> %nomfichier%.txt
@echo router-id %id_ospf% >> %nomfichier%.txt

:reseau_ospf
set /p reseau_ospf=Quel est le reseau connecté au routeur (ex : 192.168.0.0 0.0.0.255) ?
@echo network %reseau_ospf% >> %nomfichier%.txt
set /p demande_autre_reseau_ospf= Faut-il configurer un autre reseau dans le routeur OSPF (oui/non) ?
if /I "%demande_autre_reseau_ospf%"=="oui" (goto reseau_ospf)
if /I "%demande_autre_reseau_ospf%"=="o" (goto reseau_ospf)
if /I "%demande_autre_reseau_ospf%"=="y" (goto reseau_ospf)
if /I "%demande_autre_reseau_ospf%"=="yes" (goto reseau_ospf)
if /I "%demande_autre_reseau_ospf%"=="non" (goto question_passive_ospf)
if /I "%demande_autre_reseau_ospf%"=="no" (goto question_passive_ospf)
if /I "%demande_autre_reseau_ospf%"=="n" (goto question_passive_ospf)

:question_passive_ospf
set/p demande_autre_passive_ospf=Faut-t-il configurer une interface passive sur le routeur OSPF ?
if /I "%demande_autre_passive_ospf%"=="oui" (goto int_passive_ospf)
if /I "%demande_autre_passive_ospf%"=="o" (goto int_passive_ospf)
if /I "%demande_autre_passive_ospf%"=="y" (goto int_passive_ospf)
if /I "%demande_autre_passive_ospf%"=="yes" (goto int_passive_ospf)
if /I "%demande_autre_passive_ospf%"=="non" (goto exit)
if /I "%demande_autre_passive_ospf%"=="no" (goto exit)
if /I "%demande_autre_passive_ospf%"=="n" (goto exit)

:int_passive_ospf
set /p num_int_pass_ospf=Quel est l'interface passive sur le routeur OSPF (ex:  g0/0, f0/0, s0/0/0) ?
@echo passive-interface %num_int_pass_ospf% >> %nomfichier%.txt
goto question_passive_ospf

:exit
@echo exit >> %nomfichier%.txt 
goto question_menu

REM --------------------------------------------------------------------


:fin
REM notification de fin
@echo ***********************************************
@echo Appuiez sur une touche pour quitter le programme
pause
