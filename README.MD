# 📱 Auto Connect Android Phone - Wireless Debugging 

Este script fornece uma solução automatizada para o problema comum de reconexão do Android Studio via Wi-Fi. Como a IDE não rastreia mudanças dinâmicas de IP e Porta após reinicializações, este script utiliza o `nmap` para localizar o dispositivo e forçar a conexão via ADB. Basta executar o arquivo e ele irá buscar seu celular e fazer a conexão com a IDE.

## 📝 Resumo do Problema
Após parear o aparelho (QR Code/Pairing Code), é comum que o Android Studio perca a conexão porque:
* **Portas Dinâmicas:** O Android atribui uma porta aleatória (ex: 30001 a 65535) a cada nova sessão de Wireless Debugging.
* **Mudança de IP:** Se o celular não tiver IP estático, ele pode mudar de endereço na rede.
* **Limitação da IDE:** O Android Studio muitas vezes falha em rastrear essas mudanças de IP e porta automaticamente, perdendo o rastro do dispositivo.

---

## 🛠️ Requisitos e Instalação

### 1. Nmap para Windows
O script depende do `nmap` para encontrar a porta aberta no seu celular. Basta instalar utilizando a opção padrão.
* **Download:** [nmap.org](https://nmap.org/download.html)
* **Instalação Importante:** Durante a instalação do componente **Npcap**, você **DEVE** marcar a opção conforme a imagem abaixo para garantir que o script funcione corretamente:

![Instalação do Npcap - WinPcap Mode](assets/setup.png)
> *Certifique-se de marcar "Install Npcap in WinPcap API-compatible Mode".*

### 2. Configuração no Android
#### Ativar Wireless Debugging
* Vá em **Configurações > Opções do Desenvolvedor**.
* Ative a chave **Depuração sem fio (Wireless Debugging)**.

#### Atalho nas Configurações Rápidas
* Nas **Opções do Desenvolvedor**, procure por **Blocos de desenv. para config. rápidas**.
* Ative a opção **Depuração sem fio**.
* Isso adicionará um ícone no seu menu de atalhos (junto com Wi-Fi e Lanterna) para ligar/desligar a depuração rapidamente.

---

## 🌐 Configuração de IP Estático

Para que a identificação seja instantânea, o celular deve usar um **IP Estático**.

* **No Aparelho:** Acesse as configurações da rede Wi-Fi > Detalhes > Configurações IP > Mude de **DHCP** para **Estático**.
* **No Roteador:** Reserve o IP (ex: `192.168.3.101`) para o endereço MAC do seu celular nas configurações de DHCP do roteador.

> **Nota:** Esta configuração é segura e aplicada **apenas nesta rede específica**. Em redes externas, seu celular continuará usando DHCP normalmente.

---

## 💻 O Script (.bat)

O arquivo `.bat` realiza um scan no range de portas **30001-65535**.

> [!IMPORTANT]
> Antes de executar, abra o arquivo `.bat` e altere a variável `ANDROID_DEVICE` para o IP estático que você configurou no seu celular.

* Seu celular e computador devem estar conectados na mesma rede. Se estiverem em redes diferentes não será possível encontrar seu aparelho.

* **Vantagem:** Localiza automaticamente a porta dinâmica do Android sem intervenção manual.

* **Desvantagem:** Pode levar alguns segundos se a porta tiver mudado (devido ao range considerado para fazer a busca).
