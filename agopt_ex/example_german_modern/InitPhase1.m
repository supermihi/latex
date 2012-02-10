% ==== InitPhase1.m ====================================
function [A_Ph1,b_Ph1,c_Ph1,B_Ph1] = InitPhase1(A,b,c)

% Initialisierungen
[m n] = size(A);
A_Ph1 = A;
b_Ph1 = b;
B_Ph1 = zeros(1,m); % die Startbasis für Phase 1
c_Ph1 = zeros(1,n);
ev = []; % bereits gefundene oder konstruierte Einheitsvektoren

% Schritt 1 a), multipliziere alle Zeilen, fuer die b(i) < 0 ist, mit -1
for i=1:m
    if(b_Ph1(i) < 0)
        A_Ph1(i,:) = (-1)*A_Ph1(i,:);
        b_Ph1(i) = (-1)*b_Ph1(i);
    end    
end

% Schritt 1 b), suche nach Variablen, die in nur einer Gleichung (mit
% positivem Koeffizienten) vorkommen
for j=1:n
    if (sum(A_Ph1(:,j) > 0) == 1) && (sum(A_Ph1(:,j) < 0) == 0)
        %Finde die Stelle an der ein Eintrag ungleich null ist und
        %speichere seinen Wert
        [wert i] = max(A_Ph1(:,j));
        
        if sum(ev == i) == 0 % noch kein i-ter Einheitsvektor vorhanden
            % Normiere den entsprechenden Eintrag und passe die zugehörige
            % Zeile von A_Ph1 und den Eintrag in b_Ph1 an
            b_Ph1(i) = b_Ph1(i) / wert;
            A_Ph1(i,:) = A_Ph1(i,:) ./ wert;
            % Die zu der gerade gefundenen Spalte gehörige Variable ist
            % Basisvariable => nimm j in B_Ph1 auf
            B_Ph1(i) = j;
            % Fuer Schritt 1c) wird sich hier noch gemerkt, welche
            % Einheitsvektoren schon erzeugt wurden.
            ev = [ev i];
        end
    end
end
% Schritt 1c), künstliche Variablen für die fehlenden Einheitsvektoren erzeugen
k = n+1;
for i = 1:m
    if sum(ev == i) == 0
        % Einheitsvektor ergänzen
        A_Ph1(:,k) = eye(m)(:,i);
        % jede kuenstliche Variable ist am Anfang Basisvariable
        B_Ph1(i) = k;
        c_Ph1(k) = 1;
        k = k+1;
    end
end
end % Ende der Funktion
