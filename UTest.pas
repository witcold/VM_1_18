unit UTest;

interface

const
  Ranks: array [1..3] of Integer = (10, 100, 1000);
  Ranges: array [1..3] of Integer = (10, 100, 1000);
  Tests = 20;

  procedure Test;  

implementation

uses
  SysUtils, UIO, UHelp, UMain;

  procedure Test;
  var
    i, j, k: Integer;
    M: TMatrix;
    T, X, F: TVector;
    a1, a: Extended;
    a1max, a1sum: Extended;
    amax, asum: Extended;
  begin
    Randomize;
    PrepareOutput;
    for i := 1 to Length(Ranks) do begin
      M.N := Ranks[i];
      Writeln(OutputFile, 'Rank = ', Ranks[i]);
      for j := 1 to Length(Ranks) do begin
        Writeln(OutputFile, 'Range from ', -Ranges[j], ' to ', Ranges[j]);
        a1max := 0; a1sum := 0;
        amax := 0; asum := 0;
        for k := 1 to Tests do begin
          PrepareData(M, T, X, F, Ranges[j]);
          //Writeln(OutputFile, '  Test №', k, ', accuracy for');
          a1 := Process(M, T, F);
          //Writeln(OutputFile, '    1''s: ' +   FloatToStr(a1));
          a := GetAccuracy(F, X);
          //Writeln(OutputFile,'    X''s: ' +   FloatToStr(a));
          a1sum := a1sum + a1;
          asum := asum + a;
          if a1 > a1max then a1max := a1;
          if a > amax then amax := a;
        end;
        PrintMessage('Summary accuracy for ' + IntToStr(Tests) + ' tests:');
        PrintMessage(#9#9'MAX'#9'|'#9'AVG');
        PrintMessage('  1''s: ' + FloatToStr(a1max) + ' | ' + FloatToStr(a1sum/Tests));
        PrintMessage('  X''s: ' + FloatToStr(amax) + ' | ' + FloatToStr(a/Tests));
      end;
    end;
    CloseOutput;
  end;

end.
