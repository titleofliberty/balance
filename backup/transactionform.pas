unit transactionform;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Calendar,
  Spin, ExtCtrls, EditBtn, DateUtils, StrUtils;

type

  { TfrmTransaction }

  TfrmTransaction = class(TForm)
    btnSave: TButton;
    btnCancel: TButton;
    calDate: TCalendar;
    chkIncome: TCheckBox;
    chkCleared: TCheckBox;
    txtEndsOn: TDateEdit;
    Label5: TLabel;
    Label6: TLabel;
    pnlRepeat: TPanel;
    btnEndsOn: TRadioButton;
    btnEndsOccurrences: TRadioButton;
    txtEndsOccurrences: TSpinEdit;
    txtRepeat: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    txtAmount: TFloatSpinEdit;
    txtCategory: TComboBox;
    txtDescription: TComboBox;
    procedure btnEndsOnClick(Sender: TObject);
    procedure calDateChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure txtRepeatChange(Sender: TObject);
  private
    procedure PopulateRepeats;
    function NthStr(Nth: integer): string;
  public

  end;

var
  frmTransaction: TfrmTransaction;

implementation

{$R *.lfm}

{ TfrmTransaction }

procedure TfrmTransaction.FormCreate(Sender: TObject);
begin
  txtDescription.Items.LoadFromFile('descriptions.txt');
  txtCategory.Items.LoadFromFile('categories.txt');

  calDate.DateTime := Today();

  PopulateRepeats;
end;

procedure TfrmTransaction.txtRepeatChange(Sender: TObject);
begin

  pnlRepeat.Visible := txtRepeat.ItemIndex <> 0;

  if pnlRepeat.Visible then
  begin
    txtEndsOn.Date := IncDay(calDate.DateTime);
  end;

end;

procedure TfrmTransaction.PopulateRepeats;
var
  sl : TStringList;
  dn, mn : string;
  d, m, n, w: integer;
begin
  sl := TStringList.Create;

  d := DayOf(calDate.DateTime);
  m := MonthOf(calDate.DateTime);
  w := DayOfWeek(calDate.DateTime);
  n := NthDayOfWeek(calDate.DateTime);
  mn := DefaultFormatSettings.LongMonthNames[m];
  dn := DefaultFormatSettings.LongDayNames[w];

  sl.Add('Does not repeat');
  sl.Add(Format('Weekly on %s', [dn]));
  sl.Add(Format('Monthly on %s', [NthStr(d)]));
  sl.Add(Format('Monthly on %s %s', [NthStr(n), dn]));
  sl.Add(Format('Annually on %s %s', [mn, NthStr(d)]));
  sl.Add(Format('Annually on %s %s of %s', [NthStr(n), dn, mn]));

  txtRepeat.Items.AddStrings(sl, true);
  txtRepeat.ItemIndex := 0;
  txtRepeatChange(txtRepeat);

  FreeAndNil(sl);
end;

function TfrmTransaction.NthStr(Nth: integer): string;
var
  s, r: string;
begin
  s := Nth.ToString;
  r := RightStr(s, 1);
  if r = '1' then
    result := s + 'st'
  else if r = '2' then
    result := s + 'nd'
  else if r = '3' then
    result := s + 'rd'
  else
    result := s + 'th';
end;

procedure TfrmTransaction.btnEndsOnClick(Sender: TObject);
begin
  txtEndsOn.Enabled := btnEndsOn.Checked;
  txtEndsOccurrences.Enabled := btnEndsOccurrences.Checked;
end;

procedure TfrmTransaction.calDateChange(Sender: TObject);
begin
  PopulateRepeats;
end;

end.

