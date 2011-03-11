-- Jogo Todos vs Dengue
-- @author Rafael Carvalho
-- @author Peta5 - Telecomunicações e Software Livre (www.peta5.com.br)
-- @author MidiaCom - Laboratório de Pesquisas em Comunicação de Dados Multimídia (www.midiacom.uff.br)
-- @version 1.0

--------------
-- CONSTANTES
--------------

-- Controle de tempo
--------------------	
-- tempo de atualizacao das animacoes. Em segundos/2. 1 = 500 milesegundos
TIMERELOGIO = 8
TIMEMOSQUITO = 4
TIMEANIM = 500 -- tempo de atualizacao da animacao. Em milesegundos
TIMETOTAL = 55000 -- duracao do jogo. Em milesegundos. default = 55000

-- Mensagens
-------------
TEXTPONTUACAO = "Total de Pontos:"
TITULOCLASSIFICACAO = "Classificacao:"
TEXTOCLASSIFICACAO = {"Junior","Intermediario","Avancado","Terror dos Mosquitos"}
TITULOMSGCLASSIFICACAO = "Mensagem:"
TEXTOMSGCLASSIFICACAO = {"Muito Ruim :-(", "Precisa Melhorar :-|","Muito Bom :-)","Voce eh o cara! :-O"}

-- Areas da tela
----------------
-- possiveis posicoes para o alvo
POSICAO={{x=10,y=10},{x=30,y=200},{x=44,y=360},{x=136,y=328},{x=260,y=392},{x=100,y=2},{x=230,y=400},{x=270,y=300},{x=300,y=160},{x=330,y=330},{x=400,y=20},{x=431,y=270},{x=550,y=360},{x=570,y=215},{x=245,y=120}}

-----------------
-- FIM CONSTANTES
-----------------

----------------
-- IMAGENS: Carregamento das imagens, posicoes iniciais e dimensoes
----------------

-- Plano de fundo
local img = canvas:new('media/background.jpg')
local dx, dy = img:attrSize()
local fundo = { img=img, x=0, y=0, dx=dx, dy=dy }

-- Cursor
local img = canvas:new('media/mata_moscas.gif')
local dx, dy = img:attrSize()
local arma = { img=img, frame=0,x=10, y=10, dx=dx, dy=dy }

-- Alvo
local img = canvas:new('media/mosquito.png')
local dx, dy = img:attrSize()
local mosquito = { img=img, frame=0,x=260, y=150, dx=dx, dy=dy }

--Time: mostra a passagem do tempo
local img = canvas:new('media/time.png')
local dx, dy = img:attrSize()
local timePeta = { img=img, frame=0, x=566, y=10, dx=dx, dy=dy }

-- Score: mostra o fundo da area que exibe a pontuacao e tempo
local img = canvas:new('media/fundo_score.gif')
local dx, dy = img:attrSize()
local fundoScore = { img=img, frame=0, x=426, y=2, dx=dx, dy=dy }

--FundoFim: fundo do fim de jogo. Imagem exibida quando o jogo termina
local img = canvas:new('media/fundo_fim.gif')
local dx, dy = img:attrSize()
local fundoFim = { img=img, frame=0, x=5, y=30, dx=dx, dy=dy }

-- AVISOS: figura com desenhos e mensagens que aparecem no fim do jogo
local img = canvas:new('media/avisos.jpg')
local dx, dy = img:attrSize()
local avisoFim = { img=img, frame=0,x=400, y=330, dx=dx, dy=dy }

---------------
-- FIM IMAGENS
---------------

-----------------------------
-- INICIALIZACAO DE VARIAVEIS
-----------------------------
local pontos = 0 --pontiacao do jogador
-- controle para entrada e saida dos tratadores de eventos
local IGNORE = false
local TELAFIM = false
local NOFIM = true
-- para auxiliar nas animacoes
local timeMosquito
local timeRelogio

-----------
-- FUNCOES
-----------

-- Retorna um numero aleatorio entre 1 e o valor passado
-- @param param Valor para fim do intervalo de possibilidade.
function aleatorio(param)
	return math.random(param)
end	

-- Redesenho da tela <br>
-- Todos os objetos do jogo sao desenhados na tela por esta funcao
function redraw ()
	--fundo, fundoScore, arma, mosquito e time
	canvas:compose(fundo.x, fundo.y, fundo.img)
	canvas:compose(fundoScore.x, fundoScore.y, fundoScore.img)
	
	local dx2 = timePeta.dx/6
	local dx3 = mosquito.dx/2
	local dx4 = arma.dx/2
	canvas:compose(timePeta.x, timePeta.y, timePeta.img,timePeta.frame*dx2,0,dx2,timePeta.dy)	
	canvas:compose(mosquito.x, mosquito.y, mosquito.img,mosquito.frame*dx3,0,dx3,mosquito.dy)
	canvas:compose(arma.x, arma.y, arma.img,arma.frame*dx4,0,dx4,arma.dy)
	
	--score
	canvas:attrColor(0,117,178,255)
	canvas:attrFont('Times',22)
	canvas:drawText('Pontos:',438,27)
	canvas:attrFont('Times',25)
	canvas:attrColor(247,148,30,255)	
	canvas:drawText(pontos,518,26)	
	
	canvas:flush() -- atualiza a tela com os objetos desenhados
end

-- Desenho da tela de fim de jogo <br>
-- Desenha a tela com os objetos que serao apresentados no final do jogo
function drawFim()
	-- plano de fundo e fundo do fim de jogo
	canvas:compose(fundo.x, fundo.y, fundo.img)
	canvas:compose(fundoFim.x, fundoFim.y, fundoFim.img)
	
	-- as mensagens que aparecem aleatoriamente no final do jogo	
	local tx5 = avisoFim.dx/12
	canvas:compose(avisoFim.x, avisoFim.y, avisoFim.img,avisoFim.frame*tx5,0,tx5,avisoFim.dy)
	
	-- pontuacao
	canvas:attrColor(47,47,47,255)	
	canvas:attrFont('Times',25)
	canvas:drawText(TEXTPONTUACAO,40,150)	
	canvas:attrFont('Times',27)
	canvas:attrColor(247,148,30,255)	
	canvas:drawText(pontos,247,150)	
	
	-- classificacao e mensagens de acordo com a pontuacao
	if pontos <= 10 then
		textoClassificacao = TEXTOCLASSIFICACAO[1]
		textoMsgClassificacao = TEXTOMSGCLASSIFICACAO[1]
	elseif (pontos > 10) and (pontos <= 40) then
		textoClassificacao = TEXTOCLASSIFICACAO[2]
		textoMsgClassificacao = TEXTOMSGCLASSIFICACAO[2]
	elseif (pontos > 40) and (pontos <= 100) then
		textoClassificacao = TEXTOCLASSIFICACAO[3]
		textoMsgClassificacao = TEXTOMSGCLASSIFICACAO[3]
	elseif pontos > 100 then
		textoClassificacao = TEXTOCLASSIFICACAO[4]
		textoMsgClassificacao = TEXTOMSGCLASSIFICACAO[4]
	end
	
	canvas:attrColor(47,47,47,255)	
	canvas:attrFont('Times',25)
	canvas:drawText(TITULOCLASSIFICACAO,40,190)	
	
	canvas:attrColor(247,148,30,255)	
	canvas:attrFont('Times',25)
	canvas:drawText(textoClassificacao,218,190)	
	
	canvas:attrColor(47,47,47,255)	
	canvas:attrFont('Times',25)
	canvas:drawText(TITULOMSGCLASSIFICACAO,40,230)	
	
	canvas:attrColor(247,148,30,255)	
	canvas:attrFont('Times',25)
	canvas:drawText(textoMsgClassificacao,188,230)
	
	canvas:flush() -- atualizacao da tela	
	
end

-- Funcao de colisao <br>
-- Chamada a cada tecla de selecao (ENTER) pressionada <br>
-- Checa se o cursor esta em cima do alvo.
-- @param A Objeto cursor.
-- @param B Objeto alvo.
-- @return true se houve colisao
-- @retuen false se nao houve colisao
function collide (A, B)
	local ax1, ay1 = A.x, A.y
	local ax2, ay2 = ax1+(A.dx/2), ay1+A.dy --mudanca realizada por causa dos frames a mais
	local bx1, by1 = B.x, B.y
	local bx2, by2 = bx1+(B.dx/2), by1+B.dy --mudanca realizada por causa dos frames a mais

	if ax1 > bx2 then
		return false
	elseif bx1 > ax2 then
		return false
	elseif ay1 > by2 then
		return false
	elseif by1 > ay2 then
		return false
	end

	return true
end


-- Funcao de tratamento de eventos <br>
-- Responsavel pelas acoes vindas do controle remoto
-- @param evt Evento recebido do formatador NCL
function handler (evt)
	-- apenas eventos de tecla me interessam
	if evt.class == 'key' and evt.type == 'press' then
		
		if not IGNORE then
		-- movimento do cursor. apenas as setas movem o cursor
			if evt.key == 'CURSOR_UP' then
				if arma.y > 10 then
					arma.y = arma.y - 50
				end
			elseif evt.key == 'CURSOR_DOWN' then
				if arma.y < 400 then
					arma.y = arma.y + 50
				end
			elseif evt.key == 'CURSOR_LEFT' then
				if arma.x > 10 then
					arma.x = arma.x - 50
				end
			elseif evt.key == 'CURSOR_RIGHT' then
				if arma.x < 550 then
					arma.x = arma.x + 50
				end
			end

			-- redesenha a tela toda
			arma.frame = 0
			mosquito.frame = 0		
			redraw()

			-- testa se o cursor foi precionado em cima do alvo
			if evt.key == 'ENTER' then
				--event.post('out', {class='ncl', type='presentation', area='Tapa', transition='starts'})
				arma.frame = 1
				redraw()
				--event.post('out', {class='ncl', type='presentation', area='Tapa', transition='stops'})
				if collide(arma, mosquito) then
					-- se selecionar o alvo exibe alvo atingido e soma pontos
					mosquito.frame = 1
					arma.frame = 1
					pontos = pontos + 10
				
					redraw() -- atualiza a tela
				
					IGNORE = true -- impede que o movimento do cursor durante a exibicao do alvo atingido
					event.timer(800, function()
						print ("acertou :-)")
						IGNORE = false
						event.post('in', { class='user',time=timeGeral,cont=1})
						end)
				end
			end
		
		-- ao termino do jogo, posta eventos que serao responsaveis por reiniciar o jogo
		elseif IGNORE then
			if evt.key == 'YELLOW' then
				print("tecla amarela pressionada")
				event.post('out', {class='ncl', type='presentation', area='ReStart',transition='starts'})
				event.post('out', {class='ncl', type='presentation', area='ReStart',transition='stops'})
				event.post('out', {class='ncl', type='presentation', transition='stops'})
			end
		
		end
	end
end

-- registra a funcao como tratador de eventos
event.register(handler)


-- Funcao de tratamento de eventos <br>
-- Responsavel pelo movimento ao mosquito e relogio
-- @param evt Evento recebido do formatador NCL
function animObjs(evt)
	
	if IGNORE then
			return
		end	
	
	--seta nivel de dificuldade
	if evt.property == 'nivel' then
		print ("entrei no nivel")
		print (evt.property)
		if evt.value == 'verao' then
			TIMEMOSQUITO = 1
			print (TIMEMOSQUITO)
		elseif evt.value == 'primavera' then
			TIMEMOSQUITO = 4
			print (TIMEMOSQUITO)
		elseif evt.value == 'outono' then
			TIMEMOSQUITO = 7
			print (TIMEMOSQUITO)
		end
	end
	
	-- executa animacao na primeira inicializacao e ao receber um evento da classe user
	if (evt.class == 'ncl' and evt.type == 'presentation' and evt.action == 'start') or (evt.class == 'user') then

		local timeGeral = event.uptime() --tempo desde o inicio jogo
		
		-- Verifica se o tempo do jogo ja terminou
		if timeGeral > TIMETOTAL then 
			IGNORE = true
			--event.post('out', {class='ncl', type='presentation', area='SomMosquito', transition='starts'})
			NOFIM = false
			
			-- Desenha a tela de fim de jogo
			avisoFim.frame = (aleatorio(12) - 1)
			drawFim()
			--event.post('out', {class='ncl', type='presentation', area='SomMosquito', transition='stops'})
		end
		
		--animacao do mosquito
		if evt.cont == nil then
			timeMosquito = 0
		else
			timeMosquito = timeMosquito + evt.cont
		end
		if timeMosquito > TIMEMOSQUITO then
			mosquito.x = POSICAO[aleatorio(#POSICAO)].x
			mosquito.y = POSICAO[aleatorio(#POSICAO)].y			
			timeMosquito = 0
		end
		
		--animacao relogio
		if evt.cont == nil then
			timeRelogio = 0
		else
			timeRelogio = timeRelogio + evt.cont
		end
		
		if timeRelogio > TIMERELOGIO then
			if evt.cont == nil then
				timePeta.frame = 0
			else
				timePeta.frame = timePeta.frame + evt.cont
			end
			if timePeta.frame > 5 then
				timePeta.frame = 0
			end
			timeRelogio = 0
		end		
		
		-- Espera TIMEANIM e depois posta evento da classe user. Serve como um clock para a animacao
		event.timer (TIMEANIM,function()   event.post('in', { class='user',time=timeGeral,cont=1}) end)
		mosquito.frame = 0
		arma.frame = 0		
		-- Se o jogo nao terminou atualiza a tela
		if NOFIM then
			redraw()
		end
	end
end

-- Registra a funcao como tratador de eventos
event.register(animObjs)