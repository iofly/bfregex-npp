        ��  ��                  (  ,   �� B F R E G E X       0 	        (                  �  �          ��d��d��d��d��d��d��d��d��d��d��d��d��d��d��d��d��d��d��d��d��d��d��d��d��d��d��d��a��\��d��d��d��d��d��d��d��d��d��d��d��d��d��dPi@333��\��d��d��d��d��d��d��d��d��d��d��d��d��d��]��V��d��d��d��d��d��d��d��d��d��d��d��d��d��d��_��V��d��d��d��dXwCl�L��cWtBq�N��d��d��d��d��dm�M7;5}�S��d��d��df�I333Rl@333~�S��d��d��d��d��d��WI\=333YyC��d��d��U333333>G8��Z��d��d��d��d��c��d��dq�N333��UWuC333333333333333p�N��d��d]ESmA��d��d��\333|�S��W~�To�M333��Yx�Q��\��d��dSnA443SmA`�F?H8=D7��_��d��d}�S333��`��d��d��d��d��^h�JLa>BN9ToB��[��d��d��d��d��[��d��d��d��d��d��d��d��d��d��d��d��d��d��d��d��d��d��d��d��d��d��d��d��d��d��d��d��d��d��d��d��d��d��d��d��d��d��d��d��d��d��d��d��d�      �� ��     	        (       @         �  �  �        ��d p�M ��X _�F 333 ��^ ��Y m�L \E K_= VsB g�J ��V Ph? ��Y ��b BO9 [|D ��` Mc> ��W s�O YxC ��W GX< f�I ��X CQ9 ��U {�R Z{D @L8 684 a�G ��V ��\ a�G v�P ^�F ��\ z�R h�J _�F ��X ��\ 573 ~�S ��\ K`= ~�T VtB :?6 ��Y ��^ x�Q Rk@ ��[ WuB t�O j�K 7<4 ��b GW; EU: u�P ��Z Qk@ :A5 ��c ��` TpA ��a BP9 ��U <D7 s�O Rm@ d�H ToA l�L <C7 ��c w�P x�Q l�L j�K q�N ��U w�P                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    X                            VW                           U6                           QT                                                                                             R	S        LM   #NO            PQ       F: GHI           JK      @ABCD           BE     	<6            =6>?     89                :;   123!4       5      67 +     ,-.     /0 &'    ()     *       !"#$%                                                  	
                                                                                                                                                                                                                                                                                                                                                                                                     4   �� B F R E G E X D A R K       0	                  �   p  4   ��
 D B T E M P L A T E         0 	        CREATE TABLE "regexlib" (
    "regexid" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    "title" TEXT NOT NULL,
    "created" BIGINT NOT NULL,
    "modified" BIGINT NOT NULL,
    "opencount" INTEGER NOT NULL,
    "savecount" INTEGER NOT NULL,
    "runcount" INTEGER NOT NULL,
    "expression" TEXT NOT NULL,
    "flag_ignorecase" INTEGER NOT NULL,
    "flag_singleline" INTEGER NOT NULL,
    "flag_multiline" INTEGER NOT NULL,
    "flag_ignorepatternspace" INTEGER NOT NULL,
    "flag_explicitcapture" INTEGER NOT NULL,
    "flag_notempty" INTEGER NOT NULL
)
----------
CREATE TABLE "valuetype" (
    "valuetypeid" INTEGER PRIMARY KEY NOT NULL,
    "description" TEXT NOT NULL
)
----------
CREATE TABLE "settings" (
        "settingid" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        "settingname" TEXT NOT NULL,
        "settingvalue" TEXT NOT NULL,
        "valuetypeid" INTEGER NOT NULL,
	"active" INTEGER NOT NULL DEFAULT (1),
    FOREIGN KEY(valuetypeid) REFERENCES valuetype(valuetypeid)
)
----------
INSERT INTO main.valuetype
(valuetypeid, description)
VALUES
(1, 'integer')
----------
INSERT INTO main.valuetype
(valuetypeid, description)
VALUES
(2, 'string')
----------
INSERT INTO main.valuetype
(valuetypeid, description)
VALUES
(3, 'bool')
----------
INSERT INTO main.valuetype
(valuetypeid, description)
VALUES
(4, 'datetime')