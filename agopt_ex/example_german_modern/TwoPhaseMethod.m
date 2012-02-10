% ==== TwoPhaseMethod.m ====================================
function [EndTab x_opt z_opt] = TwoPhaseMethod(A,b,c, rule)

[m n] = size(A);
if (nargin < 4) % keine Regel angegeben -> Standardregel von Blatt3
    rule = 'blatt3';
end
% Umwandeln der Eingabedaten auf das für Phase 1 nötige Format
[A_Ph1,b_Ph1,c_Ph1,B_Ph1] = InitPhase1(A,b,c);

% Phase 1: Minimiere die Hilfszielfunktion (beachte: Funktion 'simplex'
% wurde so abgeändert, dass sie auch die optimale Basis zurückgibt)
[Tab_Ph1 x_Ph1 zfw_Ph1 B_Ph2] = simplex(A_Ph1,b_Ph1,c_Ph1,B_Ph1, rule);

% Überprüfen, ob der Wert der Hilfszielfunktion null ist
if zfw_Ph1 > 1e-10 % wg. numerischer Ungenauigkeit
    
    % Zielwert ungleich null, das Ausgangsproblem war unzulaessig
    EndTab = Tab_Ph1;
    x_opt = [];
    z_opt = [];
    disp('Das Problem ist unzulaessig!')

else
    % Zielwert ist null, überprüfe, ob sich noch künstliche Variablen
    % in der Basis befinden und pivotiere diese ggf. heraus,
    % um eine zulässige Startbasis für Phase 2 zu erhalten
    while sum(B_Ph2 > n) > 0 
        
        % künstliche Basisvariable finden und Pivotzeile bestimmen
        [dummy z] = max(Tab_Ph1(2:m+1,max(B_Ph2)+1));
        % Pivotspalte wählen, so dass eine echte Variable in die Basis
        % eintritt
        [dummy s] = max(abs(Tab_Ph1(z+1,2:n+1)));
        % Pivotoperation durchführen
        [Tab_Ph1, B_Ph2] = pivot_operation(z,s,Tab_Ph1,B_Ph2);
    end
        
    %lese aus dem Endtableau von Phase 1 die nötigen Daten aus
    A_Ph2 = Tab_Ph1(2:m+1,2:n+1);
    b_Ph2 = Tab_Ph1(2:m+1,size(Tab_Ph1,2));
    
    % Phase 2: Simplex mit Original-Zielfunktion
    [EndTab x_opt z_opt] = simplex(A_Ph2,b_Ph2,c,B_Ph2, rule);
end
end
