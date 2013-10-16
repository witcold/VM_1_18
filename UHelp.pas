unit UHelp;

interface

type
  TType = Single;
  TVector = array of TType;
  TMatrix = record
    N: Integer;
    A, B, C, P, Q: TVector;
  end;

  procedure FillVector (var V: TVector; Length, Min, Max: integer);
  function GetRightValue (var M: TMatrix; var T, X: TVector): TVector;
  procedure PrepareData (var M: TMatrix; var T, X, F: TVector; Range: Integer);
  procedure LoadData (var M: TMatrix; var X, F: TVector);
  procedure PrintVector (var F: TextFile; const V: TVector; Length: integer);  
  procedure PrintMatrix (var M: TMatrix; var T, X, F: TVector; S: String);

implementation

uses
  SysUtils, UIO;

  procedure FillVector (var V: TVector; Length, Min, Max: integer);
  var
    i: Integer;
  begin
    SetLength(V, Length+1);
    for i := 1 to Length do
      //V[i] := Min + Random * (Max - Min);
      V[i] := Min + Random(Max) - Min;
  end;

  function GetRightValue (var M: TMatrix; var T, X: TVector): TVector;
  var
    i: Integer;
  begin
    with M do begin
      SetLength(Result, N+1);
      for i := 1 to N do
        Result[i] := T[i]*X[1];
      for i := 2 to N do begin
        Result[1] := Result[1] + P[i]*X[i];
        Result[N] := Result[N] + Q[i]*X[i];
      end;
      Result[2] := Result[2] + B[2]*X[2] + C[2]*X[3];
      for i := 3 to N-1 do
        Result[i] := Result[i] + A[i]*X[i-1] + B[i]*X[i] + C[i]*X[i+1];
    end
  end;

  procedure PrepareData (var M: TMatrix; var T, X, F: TVector; Range: Integer);
  begin
    with M do begin
      FillVector(A, N, -Range, Range);
      FillVector(B, N, -Range, Range);
      FillVector(C, N, -Range, Range);
      FillVector(P, N, -Range, Range);
      FillVector(Q, N, -Range, Range);
      FillVector(X, N, -Range, Range);
      FillVector(T, N, 0, 0);
      T[1] := P[1];
      T[2] := A[2];
      T[N] := Q[1];
    end;
    F:=GetRightValue(M, T, X);
  end;

  procedure PrintMatrix (var M: TMatrix; var T, X, F: TVector; S: String);
  var
    i, j: Integer;
    tmp: TVector;
  begin
    tmp:=GetRightValue(M, T, X);
    PrintMessage(S);
    with M do begin
      Print(T[1]);
      for i := 2 to N do
        Print(P[i]);
      PrintRight(F[1],tmp[1]);
      for i := 2 to N-1 do begin
        Print(T[i]);
        for j := 2 to i-2 do
          Print(0);
        if (i > 2) then
          Print(A[i]);
        Print(B[i]);
        Print(C[i]);
        for j := i+2 to N do
          Print(0);
        PrintRight(F[i],tmp[i]);
      end;
      Print(T[N]);
      for i := 2 to N do
        Print(Q[i]);
      PrintRight(F[N],tmp[n]);
    end
  end;

  function LoadVector (const F: TextFile; var V: TVector): Integer;
  var
    i: Integer;
  begin
    Readln(F);
    i := 1;
    while i < Length(V) do begin
      read(F, V[i]);
      Inc(i);
    end;
    Readln(F);
    Result := i - 1;
  end;

  procedure LoadData (var M: TMatrix; var X, F: TVector);
  var
    I: TextFile;
  begin
    AssignFile(I, 'input.txt');
    Reset(I);
    with M do begin
      SetLength(A, N);
      LoadVector(I, A);
      SetLength(B, N);
      LoadVector(I, B);
      SetLength(C, N);
      LoadVector(I, C);
      SetLength(P, N+1);
      LoadVector(I, P);
      SetLength(Q, N+1);
      LoadVector(I, Q);
      SetLength(X, N+1);
      LoadVector(I, X);
      SetLength(F, N+1);
      LoadVector(I, F);
    end;
    CloseFile(I);    
  end;

  procedure PrintVector (var F: TextFile; const V: TVector; Length: integer);
  var
    i: Integer;
  begin
    for i := 1 to Length do
      Writeln(F, V[i]:21:18);
  end;

end.
