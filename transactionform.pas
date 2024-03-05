unit transactionform;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Calendar,
  Spin, ExtCtrls, EditBtn, DateUtils;

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
begin
  sl := TStringList.Create;

  sl.Add('Does not repeat');
  sl.Add('Daily');
  sl.Add(Format('Weekly on %s', [LongDayNames[DayOfWeek(calDate.DateTime)]]));
  sl.Add(Format('Weekly on %s %s', [NthStr(NthDayOfWeek(calDate.DateTime)), LongDayNames[DayOfWeek(calDate.DateTime)]]));
  sl.Add(Format('Annually on %s %d', [LongMonthNames[MonthOf(calDate.DateTime)], DayOf(calDate.DateTime)]));

  txtRepeat.Items.AddStrings(sl, true);
  txtRepeat.ItemIndex := 0;
  txtRepeatChange(txtRepeat);

  FreeAndNil(sl);
end;

function TfrmTransaction.NthStr(Nth: integer): string;
begin
  if Nth = 1 then
    result := '1st'
  else if Nth = 2 then
    result := '2nd'
  else if Nth = 3 then
    result := '3rd'
  else if Nth = 4 then
    result := '4th'
  else if Nth = 5 then
    result := '5th'
  else
    result := '';
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

