# Copyright (c) 2001-2003 John Graham-Cumming
#
#   This file is part of POPFile
#
#   POPFile is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
#
#   POPFile is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with POPFile; if not, write to the Free Software
#   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
#

# Identify the language and character set used for the interface
LanguageCode                            es
LanguageCharset                         ISO-8859-1
LanguageDirection                       ltr

# This is used to get the appropriate subdirectory for the manual
ManualLanguage                          es

# Common words that are used on their own all over the interface
Apply                                   Aplicar
On                                      Activo
Off                                     Inactivo
TurnOn                                  Activar
TurnOff                                 Desactivar
Add                                     A�adir
Remove                                  Quitar
Previous                                Previa
Next                                    Seguir
From                                    De
Subject                                 Asunto
Cc                                      Cc 
Classification                          Clasificaci�n
Reclassify                              Reclasificar
Probability                             Probabilidad
Scores                                  Puntuaciones
QuickMagnets                            Superimanes
Undo                                    Deshacer
Close                                   Cerrar
Find                                    Buscar
Filter                                  Filtro
Yes                                     Si
No                                      No
ChangeToYes                             cambiar a S�
ChangeToNo                              cambiar a No
Bucket                                  Categor�a
Magnet                                  Im�n
Delete                                  Borrar
Create                                  Crear
To                                      Para
Total                                   Total
Rename                                  Renombrar
Frequency                               Frequencia
Probability                             Probabilidad
Score                                   Puntuaci�n
Lookup                                  B�squeda
Word                                    Palabra
Count                                   Cuenta
Update                                  Actualizar
Refresh                                 Refrescar

# The header and footer that appear on every UI page
Header_Title                            POPFile - Centro de Control
Header_Shutdown                         Apagar POPFile
Header_History                          Historial
Header_Buckets                          Categor�as
Header_Configuration                    Configuraci�n
Header_Advanced                         Avanzado
Header_Security                         Seguridad
Header_Magnets                          Imanes

Footer_HomePage                         P�gina Web de POPFile
Footer_Manual                           Manual
Footer_Forums                           Foros
Footer_FeedMe                           Donar
Footer_RequestFeature                   Pedir Caracter�stica
Footer_MailingList                      Lista de Correo

Configuration_Error1                    El car�cter separador tiene que ser uno solo
Configuration_Error2                    El puerto del GUI tiene que ser un n� entre 1 y 65535
Configuration_Error3                    El puerto de escucha POP3 tiene que ser un n� entre 1 y 65535
Configuration_Error4                    El tama�o de la p�gina tiene que ser un n� entre 1 y 1000
Configuration_Error5                    El n� de dias en el historial tiene que ser un n� entre 1 y 366
Configuration_Error6                    La temporizaci�n TCP debe ser un n� entre 10 y 300
Configuration_Error7                    El puerto de escucha XML RPC listen debe ser un n�mero entre 1 y 65535
Configuration_POP3Port                  Puerto de escucha POP3
Configuration_POP3Update                Puerto actualizado a %s; este cambio ser� efectivo al siguiente reinicio de POPFile
Configuration_XMLRPCUpdate              Puerto XML-RPC actualizado a %s; este cambio ser� efectivo en el siguiente arranque de POPFile
Configuration_XMLRPCPort                Puerto de escucha XML-RPC
Configuration_SMTPPort                  Puerto de escucha SMTP
Configuration_SMTPUpdate                Puerto SMTP actualizado a %s; este cambio ser� efectivo en el siguiente arranque de POPFile
Configuration_NNTPPort                  Puerto de escucha NNTP
Configuration_NNTPUpdate                Puerto NNTP actualizado a %s; este cambio ser� efectivo en el siguiente arranque de POPFile
Configuration_POP3Separator             POP3 host:puerto:usuario caracter separador
Configuration_NNTPSeparator             NNTP host:puerto:usuario caracter separador
Configuration_POP3SepUpdate             Separador POP3 actualizado a %s
Configuration_NNTPSepUpdate             Separador NNTP actualizado a %s
Configuration_UI                        Puerto web del interface de Usuario
Configuration_UIUpdate                  El puerto web del interface de usuario ha sido actualizado a %s ; este cambio ser� efectivo en el siguiente reinicio de POPFile
Configuration_History                   N�mero de correos por p�gina
Configuration_HistoryUpdate             N� de correos por p�gina actualizado a %s
Configuration_Days                      N� de dias que se guarda el historial
Configuration_DaysUpdate                Actualizado el n�mero de d�as en historial a %s
Configuration_UserInterface             Interface de Usuario
Configuration_Skins                     Apariencias
Configuration_SkinsChoose               Elegir una apariencia
Configuration_Language                  Lenguaje
Configuration_LanguageChoose            Elegir lenguaje
Configuration_ListenPorts               Puertos de escucha
Configuration_HistoryView               Vista de Historial
Configuration_TCPTimeout                Temporizaci�n de la conexi�n TCP
Configuration_TCPTimeoutSecs            Temporizaci�n en segundos
Configuration_TCPTimeoutUpdate          Temporizaci�n de la conexi�n TCP establecida en %s
Configuration_ClassificationInsertion   Inserci�n de texto en E-Mail
Configuration_SubjectLine               Modificar la l�nea de asunto
Configuration_XTCInsertion              Insertar Clasificaci�n-X-Text
Configuration_XPLInsertion              Insertar enlace-X-POPFile
Configuration_Logging                   Registro
Configuration_None                      Nada
Configuration_ToScreen                  A Pantalla
Configuration_ToFile                    A Fichero
Configuration_ToScreenFile              A Pantalla y Fichero
Configuration_LoggerOutput              Salida
Configuration_GeneralSkins              Apariencias
Configuration_SmallSkins                Apariencias peque�as
Configuration_TinySkins                 Apariencias enanas
Configuration_CurrentLogFile            &lt;arch. de registro actual&gt;

Advanced_Error1                         '%s' ya est� en la lista de palabras ignoradas
Advanced_Error2                         Las palabras ignoradas solo pueden contener caracteres alfanum�ricos, ., _, -, � @
Advanced_Error3                         '%s' a�adida a la lista de palabras ignoradas
Advanced_Error4                         '%s' no est� en la lista de palabras ignoradas
Advanced_Error5                         '%s' quitada de la lista de palabras ignoradas
Advanced_StopWords                      Palabras Ignoradas
Advanced_Message1                       POPFile ignora las siguientes palabras de uso frecuente:
Advanced_AddWord                        A�adir palabra
Advanced_RemoveWord                     Quitar palabra

History_Filter                          &nbsp;(mostrando s�lo la categor�a <font color="%s">%s</font>)
History_FilterBy                        Filtrar Por
History_Search                          &nbsp;(buscando en de/asunto %s)
History_Title                           Mensajes Recientes
History_Jump                            Ir al mensaje
History_ShowAll                         Mostrar Todo
History_ShouldBe                        Deber�a ser
History_NoFrom                          sin l�nea de
History_NoSubject                       sin l�nea de asunto
History_ClassifyAs                      Clasificar como
History_MagnetUsed                      Im�n utilizado
History_MagnetBecause                   <b>Iman usado</b><p>Clasificado a <font color="%s">%s</font> por el iman %s </p>
History_ChangedTo                       Cambiado a <font color="%s">%s
History_Already                         Anteriormente clasificado como <font color="%s">%s</font>
History_RemoveAll                       Quitar Todo
History_RemovePage                      Quitar P�gina
History_Remove                          Para borrar las entradas en el historial clic
History_SearchMessage                   Buscar De/Asunto
History_NoMessages                      Sin mensajes
History_ShowMagnet                      magnetizado
History_ShowNoMagnet                    desmagnetizado
History_Magnet                          &nbsp;(mostrando solo mensajes clasificados por im�n)
History_NoMagnet                        &nbsp;(Mostrando s�lo mensajes no-clasificados magn�ticamente)
History_ResetSearch                     Reiniciar

Password_Title                          Contrase�a
Password_Enter                          Escriba contrase�a
Password_Go                             �Venga!
Password_Error1                         Contrase�a incorrecta

Security_Error1                         El puerto seguro tiene que ser un n� entre 1 y 65535
Security_Stealth                        Modo Oculto/Operaci�n del Servidor
Security_NoStealthMode                  No (Modo Oculto)
Security_ExplainStats                   Con esto activado POPFile envia una vez al d�a los tres valores siguientes a un script en www.usethesource.com: <b>bc</b> (el n� de categor�as que tienes), <b>mc</b> (el n� total de mensajes que ha clasificado POPFile) y <b>ec</b> (el n� total de errores de clasificaci�n).  Estos se guardan en un archivo que yo utilizar� para publicar algunas estad�sticas acerca de c�mo usa la gente POPFile y c�mo de bien les funciona.  Mi servidor web mantiene sus archivos log unos 5 d�as y luego se borran; Yo no guardo ninguna relaci�n entre las estad�sticas y sus direcciones IP individuales.
Security_ExplainUpdate                  Con esto activado POPFile envia una vez al d�a los tres valores siguientes a un script en www.usethesource.com: <b>ma</b> (el n� de versi�n de tu POPFile), <b>mi</b> (el n� de revisi�n de tu POPFile) y <b>bn</b> (el n� de compilaci�n de tu POPFile).  Si existe una nueva versi�n, POPFile recibe una respuesta en forma de gr�fico que se muestra en la parte superior de la p�gina.  Mi servidor web mantiene sus archivos log unos 5 d�as y luego se borran; Yo no guardo ninguna relaci�n entre las comprobaciones de actualizaci�n y sus direcciones IP individuales.
Security_PasswordTitle                  Contrase�a del Interface de Usuario
Security_Password                       Contrase�a
Security_PasswordUpdate                 Contrase�a actualizada a %s
Security_AUTHTitle                      Autentificaci�n por Contrase�a Segura/AUTH
Security_SecureServer                   Servidor seguro
Security_SecureServerUpdate             Actualizado el servidor seguro a %s; este cambio ser� efectivo en el siguiente reinicio de POPFile
Security_SecurePort                     Puerto seguro
Security_SecurePortUpdate               Puerto actualizado a %s; este cambio ser� efectivo en el siguiente reinicio de POPFile
Security_SMTPServer                     servidor chain SMTP
Security_SMTPServerUpdate               Actualizado el servidor chain SMTP a %s; este cambio ser� efectivo en el siguiente reinicio de POPFile
Security_SMTPPort                       Puerto chain SMTP
Security_SMTPPortUpdate                 Actualizado elpuerto chain SMTP a %s; este cambio ser� efectivo en el siguiente reinicio de POPFile
Security_POP3                           Aceptar conexiones POP3 desde m�quinas remotas (necesita reiniciar POPFile)
Security_SMTP                           Aceptar conexiones SMTP desde m�quinas remotas (necesita reiniciar POPFile)
Security_NNTP                           Aceptar conexiones NNTP desde m�quinas remotas (necesita reiniciar POPFile)
Security_UI                             Aceptar conexiones HTTP (Interface del Usuario) desde m�quinas remotas (necesita reiniciar POPFile)
Security_XMLRPC                         Aceptar conexiones XML-RPC desde m�quinas remotas (necesita reiniciar POPFile)
Security_UpdateTitle                    Comprobaci�n autom�tica de actualizaci�n
Security_Update                         Buscar actualizaciones POPFile a diario
Security_StatsTitle                     Enviar Estad�sticas
Security_Stats                          Enviar estad�sticas diariamente

Magnet_Error1                           El im�n '%s' ya exist�a en la categor�a '%s'
Magnet_Error2                           El nuevo im�n '%s' interfiere con el im�n '%s' de la categor�a '%s' y puede dar lugar a resultados ambiguos.  No se ha a�adido el nuevo.
Magnet_Error3                           Crear im�n nuevo '%s' en la categor�a '%s'
Magnet_CurrentMagnets                   Imanes Actuales
Magnet_Message1                         Los siguientes imanes hacen que el correo sea clasificado siempre en la categor�a especificada.
Magnet_CreateNew                        Crear Im�n Nuevo
Magnet_Explanation                      Hay tres tipos de imanes disponibles:</b> <ul><li><b>Direcci�n de procedencia o nombre del remitente:</b> Por ejemplo:<br /> <i>felipe@company.com</i> para capturar esta direcci�n espec�fica, <br /><i>company.com</i> para capturar a cualquiera que env�e desde <i>company.com</i>, <br /><i>Felipe Martinez</i> para capturar esa persona espec�fica,<br /> <i>Felipe</i> para capturar a todos los Felipes</li><li><b>Direcci�n <i>Para:</i> o nombre del destinatario:</b> Como un im�n De: pero con la direcci�n <i>Para:</i> en un correo</li> <li><b>Palabras en el Asunto:</b> Por ejem.: <i>hola</i> para capturar todos los mensajes con <i>hola</i> en el asunto</li></ul>
Magnet_MagnetType                       Tipo de Im�n
Magnet_Value                            Valor
Magnet_Always                           Ir siempre a categor�a
Magnet_Jump                             Ir a la p�gina iman

Bucket_Error1                           Los nombres de categor�a s�lo pueden contener las letras de la "a" a la "z" en minusculas, - y _
Bucket_Error2                           Ya existe la categor�a %s
Bucket_Error3                           Categor�a %s creada
Bucket_Error4                           Ponga por favor una palabra no-vac�a
Bucket_Error5                           Categor�a %s renombrada a %s
Bucket_Error6                           Categor�a %s borrada
Bucket_Title                            Sumario
Bucket_BucketName                       Nombre de Categor�a
Bucket_WordCount                        Contador de Palabras
Bucket_WordCounts                       N� de palabras
Bucket_UniqueWords                      Palabras �nicas
Bucket_SubjectModification              Modificaci�n del asunto
Bucket_ChangeColor                      Cambiar Color
Bucket_NotEnoughData                    No hay bastantes datos
Bucket_ClassificationAccuracy           Exactitud de la Clasificaci�n
Bucket_EmailsClassified                 correos clasificados
Bucket_EmailsClassifiedUpper            Correos Clasificados
Bucket_ClassificationErrors             Errores de clasificaci�n
Bucket_Accuracy                         Exactitud
Bucket_ClassificationCount              Contador de Clasificaci�n
Bucket_ClassificationFP                 Falsos Positivos
Bucket_ClassificationFN                 Falsos Negativos
Bucket_ResetStatistics                  Reiniciar Estad�sticas
Bucket_LastReset                        Ultimo Reinicio
Bucket_CurrentColor                     El color actual de %s es %s
Bucket_SetColorTo                       Cambiar el color de %s a %s
Bucket_Maintenance                      Mantenimiento
Bucket_CreateBucket                     Nombre de categor�a
Bucket_DeleteBucket                     Borrar categor�a
Bucket_RenameBucket                     Renombrar categor�a
Bucket_Lookup                           B�squeda
Bucket_LookupMessage                    Buscar palabra en categor�as
Bucket_LookupMessage2                   Buscar en resultados por
Bucket_LookupMostLikely                 <b>%s</b> en su mayor�a aparece en <font color="%s">%s</font>
Bucket_DoesNotAppear                    <p><b>%s</b> no aparece en ninguna de las categor�as
Bucket_DisabledGlobally                 Desactivado globalmente
Bucket_To                               a
Bucket_Quarantine                       Cuarentena

SingleBucket_Title                      Detalle de %s
SingleBucket_WordCount                  Categor�a n� de palabras
SingleBucket_TotalWordCount             N� total de palabras
SingleBucket_Percentage                 Porcentaje del total
SingleBucket_WordTable                  Palabra Table for %s
SingleBucket_Message1                   Las palabras con estrellas (*) se han usado para clasificar en esta sesi�n de POPFile.  Clic en cualquier palabra para buscar su probabilidad para todos las categor�as.
SingleBucket_Unique                     %s �nico
SingleBucket_ClearBucket                Borrar Todas las Palabras

Session_Title                           Terminada la Sesi�n POPFile
Session_Error                           Ha expirado tu sesi�n en POPFile, y puede ser debido a arrancar y parar POPFile dejando tu navegador abierto.  Por favor, pincha uno de los enlaces de arriba para seguir con POPFile.

View_Title                              Vista de un solo mensaje

Header_MenuSummary                      Esta tabla es el men� de navegaci�n que le permite acceder a cada una de las p�ginas del centro de control.
History_MainTableSummary                Esta tabla muestra el remitente y asunto de los mensajes recibidos recientemente y permite que sean revisados y reclasificados.  Pinchando en la l�nea de asunto se mostrar� el texto completo del mensaje, junto con informaci�n acerca del porqu� se clasific� as�.  La columna 'Deber�a ser' le permite especificar a qu� categor�a pertenece el mensaje, o deshacer el cambio.  La columna 'Borrar' le permite borrar mensajes espec�ficos del historial si usted ya no los necesita.
History_OpenMessageSummary              Esta tabla contiene el texto completo de un mensaje de correo, enfatizando las palabras que se han utilizado para clasificarlos acorde con la categor�a que era m�s relevante para cada una.
Bucket_MainTableSummary                 Esta tabla proporciona una visi�n global de las categor�as de clasificaci�n.  Cada fila muestra el nombre de la categor�a, el n� total de palabras de esta categor�a, el n� actual de palabras unicas en cada categor�a, si el asunto del correo se modificar� al clasificarlo es esa categor�a, si pondr� en cuarentena los mensajes recibidos en esa categor�a, y una tabla de la que escoger el color con el que se visualizar� en el centro de control lo relacionado con esa categor�a.
Bucket_StatisticsTableSummary           Esta tabla proporciona tres conjuntos de estad�sticas sobre el comportamiento global de POPFile.  El 1� es sobre lo acertada des su clasificaci�n, el 2� es cu�ntos correos se han clasificado, y en qu� categor�as, y el 3� es cu�ntas palabras hay en cada categor�a, y cu�les son sus porcentajes relativos.
Bucket_MaintenanceTableSummary          Esta tabla confiene formularios que te permiten crear, borrar o renombrar categor�as, y buscar palabras en todas las categor�as para ver sus probabilidades relativas.
Bucket_AccuracyChartSummary             Esta tabla representa gr�ficamente la exactitud de la clasificaci�n de correo.
Bucket_BarChartSummary                  Esta tabla representa gr�ficamente un distribuci�n percentual de cada una de las diferentes categor�as.  Esto se necesita para al n� de correos clasificados, y el conteo total de palabras.
Bucket_LookupResultsSummary             Esta tabla muestra las probabilidades asociadas con una palabra dada en el corpus.  Para cada categor�a, muestra la frecuencia con que se encuentra esa palabra, la probabilidad de que vuelava a encontrarse en esa categor�a, y el efecto en general sobre la puntuaci�n de la categor�a si esa palabra existe en un correo.
Bucket_WordListTableSummary             Esta tabla proporciona un listado de todas las palabras de una categor�a en particular, ordenadas por la primera letra com�n de cada fila.
Magnet_MainTableSummary                 Esta tabla muestra la lista de imanes que se han usado para autoclasificar el correo de acuerdo a reglas fijas.  Cada fila muestra c�mo est� definido el im�n, para qu� categor�a se ha ideado, y un bot�n para borrar el im�n.
Configuration_MainTableSummary          Esta tabla contiene los formularios que te permitir�n controlar la configuraci�n de POPFile.
Configuration_InsertionTableSummary     Esta tabla contiene botones que determinan cuando se har�n o no, ciertas modificaciones a la cabecera o al t�tulo del correo antes de enviarlo al cliente de correo.
Security_MainTableSummary               Esta tabla proporciona grupos de controles que afectan a la seguridad de la configuraci�n global de POPFile, si tiene que comprobar autom�ticamente la existencia de actualizaciones del programa, y si las estad�sticas sobre el comportamiento de POPFile tienen que enviarse al almac�n de datos centralizado del autor del programa (para obtener informaci�n general).
Advanced_MainTableSummary               Esta tabla proporciona un listado de palabras que POPFile ignora cuando clasifica correos debido a su frecuencia relativa en todos ellos.  Est�n ordenadas por filas de acuerdo con la primera letra de las palabras.

