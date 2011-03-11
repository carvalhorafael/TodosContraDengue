<?xml version="1.0" encoding="ISO-8859-1"?>
<ncl id="nclClicks" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
	<head>
		<regionBase>
			<region height="480" id="rgLua" left="0" top="0" width="640"/>
			<region height="480" id="rgfundo" left="0" top="0" width="640" zIndex="1"/>
			<region height="44" id="rbotao1" left="270" top="264" width="207" zIndex="2"/>
			<region height="44" id="rbotao2" left="270" top="319" width="207" zIndex="2"/>
			<region height="44" id="rbotao3" left="270" top="368" width="207" zIndex="2"/>
			<region height="40" id="rbotaosair" left="576" top="365" width="40" zIndex="2"/>
		</regionBase>
		<descriptorBase>
			<descriptor focusIndex="7" id="dsLua" region="rgLua"/>
			<descriptor focusIndex="6" id="dfundo" region="rgfundo"/>
			<descriptor focusBorderColor="blue" focusBorderWidth="-2" focusIndex="2" id="dbotao1" moveDown="3" moveUp="5" region="rbotao1"/>
			<descriptor focusBorderColor="blue" focusBorderWidth="-2" focusIndex="3" id="dbotao2" moveDown="4" moveUp="2" region="rbotao2"/>
			<descriptor focusBorderColor="blue" focusBorderWidth="-2" focusIndex="4" id="dbotao3" moveDown="5" moveUp="3" region="rbotao3"/>
			<descriptor focusBorderColor="blue" focusBorderWidth="-2" focusIndex="5" id="dbotaosair" moveDown="2" moveUp="4" region="rbotaosair"/>
		</descriptorBase>
		<connectorBase>
			<causalConnector id="onBeginStartN">
				<simpleCondition role="onBegin"/>
				<simpleAction max="unbounded" qualifier="seq" role="start"/>
			</causalConnector>
			<causalConnector id="onEndStopN">
				<simpleCondition role="onEnd"/>
				<simpleAction max="unbounded" qualifier="par" role="stop"/>
			</causalConnector>
			<causalConnector id="onEndStartN">
				<simpleCondition role="onEnd"/>
				<simpleAction max="unbounded" qualifier="par" role="start"/>
			</causalConnector>
			<causalConnector id="onBeginAbort">
				<simpleCondition role="onBegin"/>
				<simpleAction max="unbounded" qualifier="par" role="abort"/>
			</causalConnector>
			<causalConnector id="onSelectionStopN">
				<simpleCondition role="onSelection"/>
				<simpleAction max="unbounded" qualifier="par" role="stop"/>
			</causalConnector>
			<causalConnector id="onSelectionStopNStartNSetN">
				<simpleCondition role="onSelection"/>
				<connectorParam name="var"/>
				<compoundAction operator="seq">
					<simpleAction max="unbounded" qualifier="seq" role="stop"/>
					<simpleAction max="unbounded" qualifier="par" role="start"/>
					<simpleAction max="unbounded" qualifier="par" role="set" value="$var"/>
				</compoundAction>
			</causalConnector>
			<causalConnector id="onBeginStartNSetN">
				<simpleCondition role="onBegin"/>
				<connectorParam name="var"/>
				<compoundAction operator="seq">
					<simpleAction max="unbounded" qualifier="par" role="start"/>
					<simpleAction max="unbounded" qualifier="par" role="set" value="$var"/>
				</compoundAction>
			</causalConnector>
		</connectorBase>
	</head>
	<body>
		<port component="fundo" id="init"/>
		<media id="programSettings" type="application/x-ginga-settings">
			<property name="service.currentKeyMaster" value="7"/>
		</media>
		<media id="programSettings2" type="application/x-ginga-settings">
			<property name="service.currentFocus" value="2"/>
		</media>
		<media descriptor="dsLua" id="lua" src="controle.lua" type="application/x-ginga-NCLua">
			<property name="nivel"/>
			<area id="Tapa"/>
			<area id="SomMosquito"/>
			<area id="ReStart"/>
		</media>
		<!--
	<media id="somMosquito" type="audio/basic" src="media/mosquito.wav"  /> 
	<media id="somTapa" type="audio/basic" src="media/tapa.wav" /> -->
		<media id="somJogo" src="media/somJogo.mp3" type="audio/mp3"/>
		<media descriptor="dfundo" id="fundo" src="media/fundo.jpg" type="image/jpeg"/>
		<media descriptor="dbotao1" id="botao1" src="media/outono.jpg" type="image/jpeg"/>
		<media descriptor="dbotao2" id="botao2" src="media/primavera.jpg" type="image/jpeg"/>
		<media descriptor="dbotao3" id="botao3" src="media/verao.jpg" type="image/jpeg"/>
		<media descriptor="dbotaosair" id="botaosair" src="media/sair.jpg" type="image/jpeg"/>
		<!-- Interacao com o Lua  
	<link xconnector="onBeginStartN">
		<bind role="onBegin" component="lua"/>
		<bind role="start" component="somMosquito"/>
	</link>

	
	<link xconnector="onBeginStartN">
		<bind role="onBegin" component="lua" interface="Tapa"/>
		<bind role="start" component="somTapa"/>
	</link>

	<link xconnector="onEndStartN">
		<bind role="onEnd" component="somMosquito"/>
		<bind role="start" component="somMosquito"/>
	</link>
		
	<link xconnector="onBeginAbort">
		<bind role="onBegin" component="lua" interface="SomMosquito"/>
		<bind role="abort" component="somMosquito"/>
	</link>
		
	<link xconnector="onEndStopN">
		<bind role="onEnd" component="lua" interface="Tapa" />
		<bind role="stop" component="somTapa"/>
	</link>	
-->
		<!-- Tela de apresentacao do Jogo 	-->
		<!-- 
 	Elos responsaveis pelo reinicio do jogo 	
-->
		<link xconnector="onBeginStartNSetN">
			<bind component="lua" interface="ReStart" role="onBegin"/>
			<bind component="fundo" role="start"/>
			<bind component="programSettings" interface="service.currentKeyMaster" role="set">
				<bindParam name="var" value="6"/>
			</bind>
			<bind component="programSettings2" interface="service.currentFocus" role="set">
				<bindParam name="var" value="2"/>
			</bind>
		</link>
		<link xconnector="onEndStartN">
			<bind component="lua" role="onEnd"/>
			<bind component="fundo" role="start"/>
		</link>
		<!--
	FIM: Elos responsaveis pelo reinicio do jogo 	
-->
		<link xconnector="onBeginStartN">
			<bind component="fundo" role="onBegin"/>
			<bind component="botao1" role="start"/>
			<bind component="botao2" role="start"/>
			<bind component="botao3" role="start"/>
			<bind component="botaosair" role="start"/>
		</link>
		<link xconnector="onEndStopN">
			<bind component="fundo" role="onEnd"/>
			<bind component="botao1" role="stop"/>
			<bind component="botao2" role="stop"/>
			<bind component="botao3" role="stop"/>
			<bind component="botaosair" role="stop"/>
		</link>
		<link xconnector="onBeginStartN">
			<bind component="lua" role="onBegin"/>
			<bind component="somJogo" role="start"/>
		</link>
		<link xconnector="onEndStopN">
			<bind component="lua" role="onEnd"/>
			<bind component="somJogo" role="stop"/>
		</link>
		<link xconnector="onSelectionStopN">
			<bind component="botaosair" role="onSelection"/>
			<bind component="fundo" role="stop"/>
		</link>
		<!-- 
 	Elos responsaveis por iniciar o no lua, passando o nivel de dificuldade 	
-->
		<link xconnector="onSelectionStopNStartNSetN">
			<bind component="botao1" role="onSelection"/>
			<bind component="fundo" role="stop"/>
			<bind component="lua" role="start"/>
			<bind component="lua" interface="nivel" role="set">
				<bindParam name="var" value="outono"/>
			</bind>
			<bind component="programSettings" interface="service.currentKeyMaster" role="set">
				<bindParam name="var" value="7"/>
			</bind>
		</link>
		<link xconnector="onSelectionStopNStartNSetN">
			<bind component="botao2" role="onSelection"/>
			<bind component="fundo" role="stop"/>
			<bind component="lua" role="start"/>
			<bind component="lua" interface="nivel" role="set">
				<bindParam name="var" value="primavera"/>
			</bind>
			<bind component="programSettings" interface="service.currentKeyMaster" role="set">
				<bindParam name="var" value="7"/>
			</bind>
		</link>
		<link xconnector="onSelectionStopNStartNSetN">
			<bind component="botao3" role="onSelection"/>
			<bind component="fundo" role="stop"/>
			<bind component="lua" role="start"/>
			<bind component="lua" interface="nivel" role="set">
				<bindParam name="var" value="verao"/>
			</bind>
			<bind component="programSettings" interface="service.currentKeyMaster" role="set">
				<bindParam name="var" value="7"/>
			</bind>
		</link>
		<!-- 
 	FIM: Elos responsaveis por iniciar o no lua, passando o nivel de dificuldade 	
-->
	</body>
</ncl>
