%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Números Fuzzy
%   
%   Autor: André Pacheco (pacheco.comp@gmail.com)
%   Esse arquivo implementa a classe FuzzyNumber. Com ele é possível realizar
%   as operações aritméticas com números Fuzzy, além de medir distância e 
%   realizar ranking entre dois números Fuzzy. Se seu problema é para
%   números fuzzy normalizados, ou seja, a pertinência máxima do número,
%   seja triangular ou trapezoidal, é sempre 1, basta definir apenas o
%   vetor X. Caso contrário, defina X e pertX.
%   Para mais informações vide:
%   [1] Fuzzy Sets, Lotfi A. Zadeh, 1965.
%   [2] Aggregation operators on trinagular intuitionistic fuzzy numbers
%   and its application to multi-criteria decision making problems, Liang
%   et. al., 2014
%
%   Este código é aberto para fins acadêmicos, mas lembre-se, caso utilize:
%   dê crédito a quem merece crédito. Qualquer erro encontrado, por favor, 
%   reporte via e-mail para que possa corrigi-lo.
%   Faça bom uso =)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 
 
classdef FuzzyNumber < handle 
    % Essa classe implementa números fuzzy triangulares e trapezoidais
    properties
        X      %X = [x1 x2 x3] ou X = [x1 x2 x3 x4]
        pertX  % pertinência de X | 0 < pertX < 1     
    end
     
    methods
         
        % Essa função é a construtora da classe. Ela aceita 3 entradas
        % 1 - FuzzyNumber (X,pertX);
        % 2 - FuzzyNumber (X), sendo pertX=1;
        % 3 - FuzzyNumber (), sendo X=[0 0 0] e pertX=0;
        % Não é necessário dizer se é trapezoidal ou trinagular, basta
        % utilizar um vetor com 3 ou 4 componentes para que a função
        % identifique
        function fn = FuzzyNumber(varargin)     
            if nargin == 0 
                % Se nada é passado é assumido um numero fuzzy triangular
                % vazio
                fn.X = zeros(1,3);
                fn.pertX = 0;                
                return         
            elseif nargin == 1                
                if isequal(size(varargin{1}),[1 3]) || isequal(size(varargin{1}),[1 4])
                    fn.X = varargin{1};
                    fn.pertX = 1;
                    return               
                end %if        
            elseif nargin == 2
                if isequal(size(varargin{1}),[1 3]) || isequal(size(varargin{1}),[1 4])
                    if varargin{2} > 1 || varargin{2} < 0 
                        error('Função de pertinencia fora do intervalo');
                    end %if
                    fn.X = varargin{1};
                    fn.pertX = varargin{2};                    
                    return
                end  % if            
            end %if
            error('Verifique os parâmetros do seu construtor. Existe algum erro!!')             
        end % construtor
         
        % Função utilizada para imprimir o número fuzzy de maneira mais amigável
        function display(FN)
            sizeFN = size(FN);              
            % Único número Z
            if(isequal(sizeFN,[1 1]))
                disp(' ')
                disp([inputname(1) ' =']);
                disp(' ');
                 
                if isequal(size(FN.X),[1 3])
                    fprintf(1,' <[%g, %g, %g]; %g> ',FN.X(1,1),FN.X(1,2),FN.X(1,3),FN.pertX);
                else
                    fprintf(1,' <[%g, %g, %g, %g]; %g> ',FN.X(1,1),FN.X(1,2),FN.X(1,3),FN.X(1,4),FN.pertX);
                end %if
                disp(' ');
                 
            % Matriz de números Z
            else
                disp(' ')
                disp([inputname(1) ' =']);
                disp(' ');
                rows = sizeFN(1);
                columns = sizeFN(2);
                x = FN.X;
                [m n] = size(x);
                 
                for i = 1:rows                    
                    for j = 1:columns;
                        fprintf(1,' <[');
                        for k=1:n-1
                            fprintf(1,'%g, ',FN(i,j).X(k));
                        end                            
                        fprintf(1,' %g',FN(i,j).X(k+1));
                        fprintf(1,']; %g> ',FN(i,j).pertX);
                    end %for                   
                    disp(' ');
                end %for              
            end % if
            disp(' ');           
        end %display
         
        %Essa função sobrecarrega o operador de adição (+)
        % com isso é possível somar dois números fuzzy da seguinte maneira:
        %F = F1 + F2
        function tfn = plus(tfn1,tfn2)
          tfn = FuzzyNumber;
          [m n] = size(tfn1.X);
          for i=1:n
            tfn.X(i) = tfn1.X(i) + tfn2.X(i);
          end %for
          tfn.pertX = (tfn1.pertX + tfn2.pertX) - (tfn1.pertX * tfn2.pertX);
        end % plus
         
        %Essa função sobrecarrega o operador de subtração (-)
        function tfn = minus(tfn1,tfn2)
          tfn = FuzzyNumber;
          [m n] = size(tfn1.X);
          for i=1:n
            tfn.X(i) = tfn1.X(i) - tfn2.X(i);
          end %for
          tfn.pertX = (tfn1.pertX - tfn2.pertX) + (tfn1.pertX * tfn2.pertX);
        end % minus
         
         
        % Essa função sobrecarrega o operador de multiplicação (*)
        % tanto para multiplicação entre dois numeros fuzzy quanto para
        % multiplicação fuzzy-escalar
        function tfn = mtimes(param_1, param_2)            
            tfn = FuzzyNumber;
            flag = 0;
            % verificando quais os parâmetros passados, se é escalar ou
            % fuzzy
            if isa(param_1,'FuzzyNumber') && isa(param_2,'FuzzyNumber')
                tfn1 = param_1;
                tfn2 = param_2;
                flag = 1;
            elseif isa(param_1,'FuzzyNumber')
                tfn1 = param_1;
                lambda = param_2; %escalar              
            elseif isa(param_2,'FuzzyNumber')
                tfn1 = param_2;
                lambda = param_1; %escalar                          
            end %if
             
            [m n] = size(tfn1.X);
             
            if flag == 0
                if lambda >= 0
                    for j=1:n
                        tfn.X(j) = tfn1.X(j) * lambda;
                    end
                else
                    error ('Lambda não é maior que zero');
                end% if
                tfn.pertX = 1 - (1-tfn1.pertX)^lambda;                
            else
                for j=1:n
                    tfn.X(j) = tfn1.X(j) * tfn2.X(j);
                    tfn.pertX = tfn1.pertX * tfn2.pertX;                    
                end %for
            end % if
        end % mtimes      
         
        % Essa função sobrecarrega o operador de divisão (/)
        % somente numero fuzzy / numero fuzzy
        function tfn = mrdivide(tfn1, tfn2)
            [m n] = size(tfn1.X);
            tfn = FuzzyNumber;
                                   
           for j=1:n
                tfn.X(j) = tfn1.X(j) / tfn2.X(j);
                tfn.pertX = tfn1.pertX / tfn2.pertX;                    
           end %for
            
        end % mrdivide
         
         
        % Essa função sobrecarrega o operador de potência (^) com isso é 
        % possível realizar potenciação entre um escalar e um numero fuzzy
        function tfn = mpower (tfn1,a)
            [m n] = size(tfn1.X);
            tfn = FuzzyNumber;
 
            for j=1:n
                tfn.X(j) = (tfn1.X(j))^a;
            end  
            tfn.pertX = tfn1.pertX^a;            
        end %mpower
         
        % Essa função faz comparação entre dois números fuzzys. Se o
        % primeiro for maior que o segundo a função retorna 1, se for igual
        % retorna 0 e se for menor retorna -1 (exatamente como o cmp do C)
        function result = cmp (tfn1,tfn2)    
            [m n] = size(tfn1.X);
            E1 = 0;
            E2 = 0;
            %calculando a expectativa de cada um dos números fuzzy
            for i=1:n
                E1 = E1 + tfn1.X(i);
                E2 = E2 + tfn2.X(i);
            end %for
            E1 = (E1)*(1+tfn1.pertX)/(n*2);
            E2 = (E2)*(1+tfn2.pertX)/(n*2);
             
            %calculando o score de ambos
            S1 = E1 * tfn1.pertX;
            S2 = E2 * tfn2.pertX;
             
            if S1 > S2
                result = 1;
            elseif S2 > S1
                result = -1;
            else
                result = 0;
            end %if          
        end %cmp
         
        % Essa função calcula a distância entre dois números fuzzy
        function d = distanceHamming (tfn1,tfn2)
            n = size(tfn1.X,2);                        
            d = 0;
            for i=1:n
                d = d + abs(((1+tfn1.pertX)*tfn1.X(i)) - ((1+tfn2.pertX)*tfn2.X(i)));
            end %for
            d = d/(n*2);           
        end %distanceHamming     
                 
        % Essa função normaliza uma matrix de números Fuzzy
        % Apesar de não ser totalmente pertinente a essa classe
        % é interessante te-la aqui
        function matrix = normalizeMatrixFuzzy(matrix,vector_cost_or_benefit)
            [m n] = size(matrix);   
            type = size(matrix(1,1).X,2);
            vectorMax = zeros(n,1);
            vectorMin = zeros(n,1);         
            %encontrando o máximo e mínimo de cada critério
            for j=1:n                
                max = matrix(1,j).X(type);
                min = matrix(1,j).X(1);                
                for i=1:m
                    if max < matrix(i,j).X(type)
                        max = matrix(i,j).X(type);
                    end% if                   
                    if min > matrix(i,j).X(1)
                        min = matrix(i,j).X(1);
                    end %for                   
                end %for
                vectorMax(j) = max;
                vectorMin(j) = min;
            end %for                
            for j=1:n
                if vector_cost_or_benefit(j) == 1
                    for i=1:m
                        for v=1:type
                            aux(v) = (vectorMax(j)-matrix(i,j).X(v))/(vectorMax(j)-vectorMin(j));                            
                        end %for
                        for v=1:type
                            matrix(i,j).X((type+1)-v) = aux(v);
                        end%for
                    end %for
                elseif vector_cost_or_benefit(j) == 0
                    for i=1:m
                        for v=1:type
                            matrix(i,j).X(v) = (matrix(i,j).X(v)-vectorMin(j))/(vectorMax(j)-vectorMin(j));
                        end %for   
                    end %for                   
                end%if
            end %for           
        end %normalizeMatrixFuzzy     
         
    end %methods
     
end %classdef