unit UMain;

interface

uses
  UHelp;

  function Process (var M: TMatrix; var T, F: TVector): Extended;

implementation

uses
  SysUtils;

  function Process (var M: TMatrix; var T, F: TVector): Extended;
  var
    X1, F0: TVector;
    i: Integer;
    r: Extended;
  begin
    with M do begin
      FillVector(X1, N, 1, 1);
      F0 := GetRightValue(M, T, X1);

      // ШАГ 1
      for i := 2 to N-1 do begin
        // i-я строка (делим на диагональный элемент)
        r := 1 / B[i];       B[i] := 1;
        T[i] := T[i] * r;
        C[i] := C[i] * r;
        F[i] := F[i] * r;
        F0[i] := F0[i] * r;

        // i+1 строка (избавляемся от a[i+1])
        if (i+1 < N) then begin
          r := A[i+1];       A[i+1]:=0;
          T[i+1] := -r * T[i];
          B[i+1] := B[i+1] - r*C[i];
          F[i+1] := F[i+1] - r*F[i];
          F0[i+1] := F0[i+1] - r*F0[i];
        end;

        // первая строка (избавляемся от p[i])
        r := P[i];           P[i]:=0;
        T[1] := T[1] - r*T[i];
        P[i+1] := P[i+1] - r*C[i];
        F[1] := F[1] - r*F[i];
        F0[1] := F0[1] - r*F0[i];

        // последняя строка (избавляемся от q[i])
        r := Q[i];           Q[i]:=0;
        T[N] := T[N] - r*T[i];
        Q[i+1] := Q[i+1] - r*C[i];
        F[N] := F[N] - r*F[i];
        F0[N] := F0[N] - r*F0[i];

        //PrintMatrix(M, T, X, F, 'Step 1: ' + IntToStr(i-1));
      end;

      // ШАГ 2

      // первая строка (делим)
      r := 1 / T[1];         T[1] := 1;
      P[N] := P[N] * r;
      F[1] := F[1] * r;
      F0[1] := F0[1] * r;

      //PrintMatrix(M, T, X, F, 'Step 2: 1');

      // последняя строка (вычитаем)
      r := T[N];             T[N] := 0;
      Q[N] := Q[N] - r*P[N];
      F[N] := F[N] - r*F[1];
      F0[N] := F0[N] - r*F0[1];

      //PrintMatrix(M, T, X, F, 'Step 2: 2');

      // последняя строка (делим)
      r := 1 / Q[N];         Q[N] := 1;
      F[N] := F[N] * r;
      F0[N] := F0[N] * r;

      //PrintMatrix(M, T, X, F, 'Step 2: 3');

      // первая строка (вычитаем)
      r := P[N];             P[N] := 0;
      F[1] := F[1] - r*F[N];
      F0[1] := F0[1] - r*F0[N];

      //PrintMatrix(M, T, X, F, 'Step 2: 4');

      // ШАГ 3
      for i := 2 to N-1 do begin
        // избавляемся от первого столбца
        r := T[i];           T[i] := 0;
        F[i] := F[i] - r*F[1];
        F0[i] := F0[i] - r*F0[1];
        //PrintMatrix(M, T, X, F, 'Step 3: ' + IntToStr(i-1));
      end;

      // ШАГ 4
      for i := N-1 downto 2 do begin
        // избавляемся от кодиагонали
        r := C[i];           C[i] := 0;
        F[i] := F[i] - r*F[i+1];
        F0[i] := F0[i] - r*F0[i+1];
        //PrintMatrix(M, T, X, F, 'Step 4: ' + IntToStr(N-i));
      end;
    end;
    // получаем погрешность для единичной правой части
    Result := GetAccuracy(F0,X1);
  end;

end.
