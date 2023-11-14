unit mainform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Menus, Buttons, Grids, StrUtils, DateUtils, LCLType, transactionform, IniFiles, Types;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    dlgOpen: TOpenDialog;
    dlgSave: TSaveDialog;
    grdMain: TStringGrid;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure grdMainColRowMoved(Sender: TObject; IsColumn: Boolean; sIndex,
      tIndex: Integer);
    procedure grdMainDblClick(Sender: TObject);
    procedure grdMainDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure grdMainResize(Sender: TObject);
  private
    FFileName: string;
    procedure CalcBalance();
    procedure PopulateForm(ARow: integer; AForm: TfrmTransaction);
    procedure UpdateGrid(ARow: integer; AForm: TfrmTransaction);
  public

  end;

var
  frmMain: TfrmMain;

implementation

{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  amt : Double;
  frm : TfrmTransaction;
begin
  if Key = VK_INSERT then
  begin
    frm := TfrmTransaction.Create(Self);
    PopulateForm(0, frm);
    if frm.ShowModal = mrOk then
    begin
      grdMain.InsertColRow(false, 1);
      UpdateGrid(1, frm);
    end;
  end
  else if Key = VK_DELETE then
  begin
    if grdMain.RowCount > 1 then
    begin
      grdMain.DeleteRow(grdMain.Row);
      grdMain.SaveToCSVFile(FFileName);
    end;
  end
  else if (Key = VK_C) then
  begin
    if (grdMain.Cells[6, grdMain.Row] = 'c') then
      grdMain.Cells[6, grdMain.Row] := ''
    else
      grdMain.Cells[6, grdMain.Row] := 'c';
    grdMain.Invalidate;
    grdMain.SaveToCSVFile(FFileName);
  end
  else if (Key = VK_RETURN) and (grdMain.RowCount > 1) then
  begin
    frm := TfrmTransaction.Create(Self);
    PopulateForm(grdMain.Row, frm);
    if frm.ShowModal = mrOk then
    begin
      UpdateGrid(grdMain.Row, frm);
    end;
  end
  else if (Key = VK_Q) and (ssCtrl in Shift) then
  begin
    Close;
  end
  else if (Key = VK_N) and (ssCtrl in Shift) then
  begin
    if dlgSave.Execute then
    begin
      FFileName := dlgSave.FileName;
      grdMain.Clear;
      grdMain.RowCount := 1;
      grdMain.SaveToCSVFile(FFileName);
      Caption := Format('Balance - %s', [FFileName]);
    end;
  end
  else if (Key = VK_O) and (ssCtrl in Shift) then
  begin
    if dlgOpen.Execute then
    begin
      FFileName := dlgOpen.FileName;
      grdMain.Clear;
      grdMain.RowCount := 1;
      grdMain.LoadFromCSVFile(FFileName);
      Caption := Format('Balance - %s', [FFileName]);
    end;
  end;

end;

procedure TfrmMain.grdMainColRowMoved(Sender: TObject; IsColumn: Boolean;
  sIndex, tIndex: Integer);
begin
  CalcBalance();
end;

procedure TfrmMain.grdMainDblClick(Sender: TObject);
var
  frm : TfrmTransaction;
begin
  frm := TfrmTransaction.Create(Self);
  PopulateForm(grdMain.Row, frm);
  if frm.ShowModal = mrOk then
  begin
    UpdateGrid(grdMain.Row, frm);
  end;
end;

procedure TfrmMain.grdMainDrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
var
  ts  : TTextStyle;
  str : string;
  amt : Currency;
  grd : TStringGrid;
  rct, row : TRect;
begin
  grd := TStringGrid(Sender);
  rct := aRect;
  row.TopLeft := grd.CellRect(1, aRow).TopLeft;
  row.BottomRight := grd.CellRect(5, aRow).BottomRight;
  ts.Layout := tlCenter;
  ts.SingleLine  := true;
  ts.SystemFont  := false;
  ts.Clipping    := true;

  grd.Canvas.Brush.Style := bsClear;
  rct.Inflate(-8, 0);

  if (aRow = 0) then
    ts.Alignment := taCenter
  else if (aCol > 3) then
    ts.Alignment := taRightJustify
  else
    ts.Alignment := taLeftJustify;

  if (gdFixed in aState) then
    grd.Canvas.Brush.Color := clForm
  else if (gdRowHighlight in aState) then
    grd.Canvas.Brush.Color := $F1D6AE
  else if ((aRow mod 2) = 0) and (aRow > 0) then
    grd.Canvas.Brush.Color := $DFEFD4;

  grd.Canvas.FillRect(row);

  if (aRow > 0) then
  begin
    if (aCol < 4) then
    begin
      if grd.Cells[6, aRow] = 'c' then
        grd.Canvas.Font.Color := $968B80
      else
        grd.Canvas.Font.Color := $3D2F21;
    end
    else if (aCol = 4) then
    begin
      str := grd.Cells[aCol, aRow].Replace('$', '').Replace(',', '');
      if TryStrToCurr(str, amt) then
      begin
        if (grd.Cells[6, aRow] = 'c') then
          grd.Canvas.Font.Color := $968B80
        else if (amt > 0) then
          grd.Canvas.Font.Color := $549922
        else if (amt < 0) then
          grd.Canvas.Font.Color := $2B39C0
        else
          grd.Canvas.Font.Color := $3D2F21;
      end;
    end
    else if (aCol = 5) then
    begin
      str := grd.Cells[aCol, aRow].Replace('$', '').Replace(',', '');
      if TryStrToCurr(str, amt) then
      begin
        if (amt > 0) then
          grd.Canvas.Font.Color := $549922
        else if (amt < 0) then
          grd.Canvas.Font.Color := $2B39C0;
      end;
    end;
  end;

  if (aRow = 0) then
  begin
    if (aCol = 1) then
      grd.Canvas.TextRect(rct, rct.Left, rct.Top, 'Date', ts)
    else if (aCol = 2) then
      grd.Canvas.TextRect(rct, rct.Left, rct.Top, 'Description', ts)
    else if (aCol = 3) then
      grd.Canvas.TextRect(rct, rct.Left, rct.Top, 'Category', ts)
    else if (aCol = 4) then
      grd.Canvas.TextRect(rct, rct.Left, rct.Top, 'Amount', ts)
    else if (aCol = 5) then
      grd.Canvas.TextRect(rct, rct.Left, rct.Top, 'Balance', ts);
  end
  else
   grd.Canvas.TextRect(rct, rct.Left, rct.Top, grd.Cells[aCol, aRow], ts);

end;

procedure TfrmMain.grdMainResize(Sender: TObject);
var
  w : integer;
begin
  grdMain.ColWidths[0] := grdMain.DefaultRowHeight;
  grdMain.ColWidths[1] := 160;
  grdMain.ColWidths[3] := 200;
  grdMain.ColWidths[4] := 160;
  grdMain.ColWidths[5] := 160;
  grdMain.ColWidths[6] := 0;
  w := grdMain.ColWidths[0] + grdMain.ColWidths[1] + grdMain.ColWidths[3]
   + grdMain.ColWidths[4] + grdMain.ColWidths[5] + grdMain.ColWidths[6];

  grdMain.ColWidths[2] := (grdMain.ClientWidth - w);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  ini: TIniFile;
begin
  ini := TIniFile.Create('options.ini');
  FFileName := ini.ReadString('Options', 'Resent', '');
  grdMain.ColWidths[0] := grdMain.DefaultRowHeight;
  ini.Free;
  if FFileName <> '' then
  begin
    grdMain.LoadFromCSVFile(FFileName);
    Caption := Format('Balance - %s', [FFileName]);
  end
  else
  begin
    if dlgOpen.Execute then
    begin
      FFileName := dlgOpen.FileName;
      grdMain.LoadFromCSVFile(FFileName);
    end
    else if dlgSave.Execute then
    begin
      FFileName := dlgSave.FileName;
      grdMain.SaveToCSVFile(FFileName);
    end
    else
      Close;
  end;
end;

procedure TfrmMain.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
  ini: TIniFile;
begin
  ini := TIniFile.Create('options.ini');
  ini.WriteString('Options', 'Resent', FFileName);
end;

procedure TfrmMain.CalcBalance;
var
  r: integer;
  b, a: Double;
begin
  b := 0;
  for r := grdMain.RowCount - 1 downto 1 do
  begin
    a := grdMain.Cells[4, r].Replace('$', '').Replace(',', '').ToDouble;
    b := b + a;
    grdMain.Cells[5, r] := FormatCurr('$#,##0.00', b);
  end;
  grdMain.SaveToCSVFile(FFileName);
end;

procedure TfrmMain.PopulateForm(ARow: integer; AForm: TfrmTransaction);
var
  amt: Double;
begin
  if ARow = 0 then
  begin
    AForm.calDate.DateTime := Now();
    AForm.txtDescription.Text := '';
    AForm.txtCategory.Text := '';
    AForm.chkIncome.Checked := false;
    AForm.chkCleared.Checked := false;
    AForm.txtAmount.Value := 0;
  end
  else
  begin
    AForm.calDate.DateTime := StrToDate(grdMain.Cells[1, ARow], 'yyyy-mm-dd', '-');
    AForm.txtDescription.Text := grdMain.Cells[2, ARow];
    AForm.txtCategory.Text := grdMain.Cells[3, ARow];
    if TryStrToFloat(grdMain.Cells[4, ARow].Replace('$', '').Replace(',', ''), amt) then
    begin
      AForm.chkIncome.Checked := amt > 0;
      AForm.txtAmount.Value := amt;
    end;
    AForm.chkCleared.Checked := grdMain.Cells[6, ARow] = 'c';
  end;
end;

procedure TfrmMain.UpdateGrid(ARow: integer; AForm: TfrmTransaction);
var
  amt: Double;
begin
  grdMain.Cells[1, ARow] := FormatDateTime('yyyy-mm-dd', AForm.calDate.DateTime);
  grdMain.Cells[2, ARow] := AForm.txtDescription.Text;
  grdMain.Cells[3, ARow] := AForm.txtCategory.Text;
  amt := AForm.txtAmount.Value;

  if (AForm.chkIncome.Checked) and (amt < 0) then
    amt := amt * -1
  else if (AForm.chkIncome.Checked = false) and (amt > 0) then
    amt := amt * -1;

  grdMain.Cells[4, ARow] := FormatCurr('$#,##0.00', amt);

  if (AForm.chkCleared.Checked) then
    grdMain.Cells[6, ARow] := 'c'
  else
    grdMain.Cells[6, ARow] := '';

  CalcBalance();
end;

end.

