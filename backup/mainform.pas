unit mainform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  optionsform, Menus, Buttons, Grids, StrUtils, DateUtils, LCLType, ComCtrls,
  transactionform, IniFiles, Types;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    dlgOpen: TOpenDialog;
    dlgSave: TSaveDialog;
    btnInsert: TSpeedButton;
    btnDelete: TSpeedButton;
    lblBalance: TLabel;
    lblDebits: TLabel;
    lblCredits: TLabel;
    mnuMainToolsOptions: TMenuItem;
    mnuMainTools: TMenuItem;
    pnlStatus: TPanel;
    txtFilter: TEdit;
    grdMain: TStringGrid;
    mnuMainEditInsert: TMenuItem;
    mnuMainEditDelete: TMenuItem;
    mnuMainEdit: TMenuItem;
    mnuMainFileQuit: TMenuItem;
    pnlTools: TPanel;
    Separator1: TMenuItem;
    mnuMainFileOpen: TMenuItem;
    mnuMainFileNew: TMenuItem;
    mnuMainFile: TMenuItem;
    mnuMain: TMainMenu;
    btnClear: TSpeedButton;
    procedure btnClearClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure grdMainColRowMoved(Sender: TObject; IsColumn: Boolean; sIndex,
      tIndex: Integer);
    procedure grdMainDblClick(Sender: TObject);
    procedure grdMainDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure grdMainResize(Sender: TObject);
    procedure mnuMainEditDeleteClick(Sender: TObject);
    procedure mnuMainEditInsertClick(Sender: TObject);
    procedure mnuMainFileNewClick(Sender: TObject);
    procedure mnuMainFileOpenClick(Sender: TObject);
    procedure mnuMainFileQuitClick(Sender: TObject);
    procedure mnuMainToolsOptionsClick(Sender: TObject);
    procedure txtFilterChange(Sender: TObject);
  private
    FFileName: string;
    procedure CalcBalance();
    procedure PopulateForm(ARow: integer; AForm: TfrmTransaction);
    procedure UpdateGrid(ARow: integer; AForm: TfrmTransaction);
    procedure InsertRow(ARow: integer; ADate: TDateTime; ADesc, ACat: string; AAmount: Double; ACredit, ACleared: Boolean);
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
  if (Key = VK_RETURN) and (grdMain.RowCount > 1) then
  begin
    frm := TfrmTransaction.Create(Self);
    PopulateForm(grdMain.Row, frm);
    if frm.ShowModal = mrOk then
    begin
      UpdateGrid(grdMain.Row, frm);
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
    grd.Canvas.Brush.Color := $311f24; // $F1D6AE;
  //else if ((aRow mod 2) = 0) and (aRow > 0) then
  //  grd.Canvas.Brush.Color := $DFEFD4;

  grd.Canvas.FillRect(row);

  if (aRow > 0) then
  begin
    if (aCol < 4) then
    begin
      if grd.Cells[6, aRow] = 'c' then
        grd.Canvas.Font.Color := $968B80
      else if (gdRowHighlight in aState) then
        grd.Canvas.Font.Color := $ffffff // $000000
      else
        grd.Canvas.Font.Color := $ffffff;
    end
    else if (aCol = 4) then
    begin
      str := grd.Cells[aCol, aRow].Replace('$', '').Replace(',', '');
      if TryStrToCurr(str, amt) then
      begin
        if (grd.Cells[6, aRow] = 'c') then
          grd.Canvas.Font.Color := $968B80
        else if (amt > 0) then
          grd.Canvas.Font.Color := $006FC86F // $549922
        else if (amt < 0) then
          grd.Canvas.Font.Color := $006C6CDE // $2B39C0
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
          grd.Canvas.Font.Color := $006FC86F // $549922
        else if (amt < 0) then
          grd.Canvas.Font.Color := $006C6CDE // $2B39C0;
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
  grdMain.ColWidths[0] := grdMain.DefaultRowHeight;  // Row Header
  grdMain.ColWidths[1] := 120; // Date
  grdMain.ColWidths[3] := 120; // Category
  grdMain.ColWidths[4] := 120; // Amount
  grdMain.ColWidths[5] := 120; // Balance
  grdMain.ColWidths[6] := 0;   // Cleared
  w := grdMain.ColWidths[0] + grdMain.ColWidths[1] + grdMain.ColWidths[3]
   + grdMain.ColWidths[4] + grdMain.ColWidths[5] + grdMain.ColWidths[6];

  grdMain.ColWidths[2] := (grdMain.ClientWidth - w);
end;

procedure TfrmMain.mnuMainEditDeleteClick(Sender: TObject);
begin
  if grdMain.RowCount > 1 then
  begin
    grdMain.DeleteRow(grdMain.Row);
    grdMain.SaveToCSVFile(FFileName);
  end;
end;

procedure TfrmMain.mnuMainEditInsertClick(Sender: TObject);
var
  row, cnt, i : integer;
  sd, ed, sp : TDateTime;
  amt : Double;
  frm : TfrmTransaction;
  occ, cdt, cld : boolean;
  desc, cat : string;
begin
  occ := false;
  frm := TfrmTransaction.Create(Self);
  PopulateForm(0, frm);
  if frm.ShowModal = mrOk then
  begin
    sd   := frm.calDate.DateTime;
    sp   := frm.calDate.DateTime;
    ed   := frm.txtEndsOn.Date;
    occ  := frm.btnEndsOccurrences.Checked;
    cnt  := frm.txtEndsOccurrences.Value;
    cat  := frm.txtCategory.Text;
    cdt  := frm.chkIncome.Checked;
    cld  := frm.chkCleared.Checked;
    desc := frm.txtDescription.Text;

    if frm.txtRepeat.ItemIndex = 0 then // No repeat
    begin
      row := 1;
      if grdMain.RowCount > 1 then row := grdMain.Row;
      grdMain.InsertColRow(false, row);
      UpdateGrid(row, frm);
      grdMain.Row := row;
    end
    else if frm.txtRepeat.ItemIndex = 1 then // Weekly
    begin
      if occ then
      begin
        for i := 0 to cnt - 1 do
        begin
          InsertRow(1, sp, desc, cat, amt, cdt, cld);
          sp := IncWeek(sp);
        end;
      end
      else
      begin

      end;
    end;
  end;
end;

procedure TfrmMain.mnuMainFileNewClick(Sender: TObject);
begin
  if dlgSave.Execute then
  begin
    FFileName := dlgSave.FileName;
    grdMain.Clear;
    grdMain.RowCount := 1;
    grdMain.SaveToCSVFile(FFileName);
    Caption := Format('Balance - %s', [FFileName]);
  end;
end;

procedure TfrmMain.mnuMainFileOpenClick(Sender: TObject);
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

procedure TfrmMain.mnuMainFileQuitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.mnuMainToolsOptionsClick(Sender: TObject);
var
  frm: TfrmOptions;
  lst: TStringList;
begin
  frm := TfrmOptions.Create(Self);
  if frm.ShowModal = mrOK then
  begin
    lst := TStringList.Create;
    lst.Sorted := true;
    lst.Duplicates := dupIgnore;
    lst.AddStrings(frm.txtDescriptions.Lines, true);
    frm.txtDescriptions.Lines.AddStrings(lst, true);
    frm.txtDescriptions.Lines.SaveToFile('descriptions.txt');

    lst := TStringList.Create;
    lst.Sorted := true;
    lst.Duplicates := dupIgnore;
    lst.AddStrings(frm.txtCategorys.Lines, true);
    frm.txtCategorys.Lines.AddStrings(lst, true);
    frm.txtCategorys.Lines.SaveToFile('categories.txt');
  end;
  frm.Free;
end;

procedure TfrmMain.txtFilterChange(Sender: TObject);
var
  r: integer;
begin
  if grdMain.RowCount = 0 then exit;

  if txtFilter.Text = '' then
  begin
    for r := 1 to grdMain.RowCount - 1 do
      grdMain.RowHeights[r] := grdMain.DefaultRowHeight;
  end
  else
  begin
    for r := 1 to grdMain.RowCount - 1 do
    begin
      if AnsiContainsText(grdMain.Cells[2, r], txtFilter.Text) or AnsiContainsText(grdMain.Cells[3, r], txtFilter.Text) then
        grdMain.RowHeights[r] := grdMain.DefaultRowHeight
      else
        grdMain.RowHeights[r] := 0;
    end;
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
  begin
    grdMain.LoadFromCSVFile(FFileName);
    Caption := Format('Balance - %s', [FFileName]);
    CalcBalance;
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

procedure TfrmMain.btnClearClick(Sender: TObject);
begin
  txtFilter.Text := '';
end;

procedure TfrmMain.CalcBalance;
var
  r: integer;
  b, d, c, a: Double;
begin
  b := 0;
  d := 0;
  c := 0;
  for r := grdMain.RowCount - 1 downto 1 do
  begin
    if grdMain.Cells[4, r] <> '' then
      a := grdMain.Cells[4, r].Replace('$', '').Replace(',', '').ToDouble
    else
      a := 0;
    if a < 0 then d := d + a;
    if a > 0 then c := c + a;
    b := b + a;
    grdMain.Cells[5, r] := FormatCurr('$#,##0.00', b);
  end;
  lblCredits.Caption := Format('Credits: %s', [FormatCurr('$#,##0.00', c)]);
  lblDebits.Caption := Format('Debits: %s', [FormatCurr('$#,##0.00', d)]);
  lblBalance.Caption := Format('Balance: %s', [FormatCurr('$#,##0.00', b)]);
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

procedure TfrmMain.InsertRow(ARow: integer; ADate: TDateTime; ADesc,
  ACat: string; AAmount: Double; ACredit, ACleared: Boolean);
var
  amt: double;
begin
  grdMain.Cells[1, ARow] := FormatDateTime('yyyy-mm-dd', ADate);
  grdMain.Cells[2, ARow] := ADesc;
  grdMain.Cells[3, ARow] := ACat;
  amt := AAmount;

  if (ACredit) and (amt < 0) then
    amt := amt * -1
  else if (ACredit = false) and (amt > 0) then
    amt := amt * -1;

  grdMain.Cells[4, ARow] := FormatCurr('$#,##0.00', amt);

  if (ACleared) then
    grdMain.Cells[6, ARow] := 'c'
  else
    grdMain.Cells[6, ARow] := '';

  CalcBalance();
end;

end.

