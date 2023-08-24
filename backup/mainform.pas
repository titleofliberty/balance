unit mainform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Menus, Buttons, Grids, StrUtils, DateUtils, LCLType, transactionform, IniFiles;

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
      grdMain.DeleteRow(grdMain.Row);
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

procedure TfrmMain.FormCreate(Sender: TObject);
var
  ini: TIniFile;
begin
  ini := TIniFile.Create('options.ini');
  FFileName := ini.ReadString('Options', 'Resent', '');
  grdMain.ColWidths[0] := grdMain.DefaultRowHeight;
  ini.Free;
  if FFileName <> '' then
    grdMain.LoadFromCSVFile(FFileName)
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
  if AForm.chkIncome.Checked and (amt < 0) then
    amt := amt * -1
  else if AForm.chkIncome.Checked = false and (amt > 0) then
    amt := amt * -1;
  grdMain.Cells[4, ARow] := FormatCurr('$#,##0.00', amt);
  CalcBalance();
end;

end.

