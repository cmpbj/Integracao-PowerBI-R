# Integração entre Power BI e Linguagem R

Este repositório tem como objetivo servir para o aprofundamento do conteúdo ensinado no capítulo 12 do curso *Microsoft Power BI Para Data Science, Versão 2.0*, promovido pela Data Science Academy.

O Capítulo 12 trata da integração da Linguagem R com o Power BI, ensinando como utilizar R para manipular os dados no Power Query e para gerar gráficos, o que é uma grande vantagem, já que permite a criação de gráficos não disponíveis na ferramenta.

Os dados utilizados estão disponíveis no portal dados.gov.br (https://dados.gov.br/dataset/serie-historica-de-precos-de-combustiveis-por-revenda). Tratase da série histórica de preços de combustíveis disponibilizada pela Agência Nacional do Petróleo, Gás Natural e Biocombustíveis (ANP). 

Apesar de ser uma ferramenta bastante interessante oferecida pela Microsoft, a integração entre o Power BI e a Linguagem R para geração dos gráficos possui algumas limitações. Dentre elas, o tamanhos dos dados usados por um visual do R para plotar, que estão limitados a 150 mil linhas. Caso mais de 150.000 linhas forem selecionadas, somente as primeiras 150.000 linhas serão usadas. Para um passo a passo de como realizar a integração, é possível acessar este link (https://docs.microsoft.com/pt-br/power-bi/create-reports/desktop-r-visuals). Além disso, no site consta uma lista com as limitações conhecidas, reproduzidas abaixo:

Os visuais do R no Power BI Desktop têm as seguintes limitações:

* Tamanhos de dados: Dados usados por um visual do R para plotar estão limitados a 150 mil linhas. Se mais de 150.000 linhas forem selecionadas, somente as primeiras 150.000 linhas serão usadas e uma mensagem será exibida na imagem.

* Tamanho de saída: o visual do R tem um limite de tamanho de saída de 2 MB.

* Resolução: todos os visuais do R são exibidos com 72 dpi.

* Dispositivo de plotagem: somente a plotagem para o dispositivo padrão é compatível.

* Tempos de cálculo: se um cálculo de visual do R exceder cinco minutos, causará um erro de tempo limite.

* Relacionamentos: assim como acontece com outros visuais do Power BI Desktop, se os campos de dados de tabelas diferentes sem uma relação definida entre eles forem selecionados, ocorrerá um erro.

* Atualizações: Visuais R são atualizados após atualizações de dados, filtragem e realce. No entanto, a própria imagem não é interativa e não pode ser a origem da filtragem cruzada.

* Realces: os visuais do R responderão se você realçar outros visuais, mas não puder selecionar elementos no visual do R para realizar filtragem cruzada de outros elementos.

* Exibir dispositivos: Somente plotagens realizadas no dispositivo de vídeo padrão R são exibidos corretamente na tela. Evite o uso explícito de um dispositivo de vídeo diferente do R.

* Renomeação de coluna: os visuais do R não dão suporte à renomeação de colunas de entrada. As colunas serão referenciadas pelo nome original durante a execução do script.

* Instalações do RRO: nesta versão, a versão de 32 bits do Power BI Desktop não identifica automaticamente as instalações do RRO; você deve fornecer manualmente o caminho para o diretório da instalação do R em Opções e configurações>Opções>Script do R.
