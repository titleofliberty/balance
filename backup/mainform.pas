unit mainform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  balanceframe, GizmoCalendar, htmlcolors, transactionform;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    calMonth: TGizmoCalendar;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    pnlBalances: TPanel;
    pnlClient: TPanel;
    pnlTop: TPanel;
    pnlLeft: TPanel;
    pnlExpenses: TScrollBox;
    pnlTransactions: TFlowPanel;
    boxTransactions: TScrollBox;
    sprMain: TSplitter;
    procedure FormCreate(Sender: TObject);
  private
    FBalance: TfraBalance;
    FCredits: TfraBalance;
    FDebits: TfraBalance;
  public

  end;

var
  frmMain: TfrmMain;

implementation

{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.FormCreate(Sender: TObject);
var
  frm : TfrmTransaction;
begin
  FDebits  := TfraBalance.Create(pnlBalances);
  FDebits.Name := 'balDebits';
  FDebits.Parent  := pnlBalances;
  FDebits.Align := alTop;
  FDebits.Height := 32;
  FDebits.Title := 'Expenses';
  FDebits.ValueColor  := htmlcolors.clHTMLCrimson;

  FCredits := TfraBalance.Create(pnlBalances);
  FCredits.Name := 'balCredits';
  FCredits.Parent := pnlBalances;
  FCredits.Align := alTop;
  FCredits.Height := 32;
  FCredits.Title := 'Income';
  FCredits.ValueColor := htmlcolors.clHTMLForestGreen;

  FBalance := TfraBalance.Create(pnlBalances);
  FBalance.Name := 'balBalance';
  FBalance.Parent := pnlBalances;
  FBalance.Align := alTop;
  FBalance.Height := 32;
  FBalance.Title := 'Balance';
  FBalance.ValueColor := htmlcolors.clHTMLRoyalBlue;

  frm := TfrmTransaction.Create(pnlTransactions);
  frm.Parent := pnlTransactions;
  frm.Show;
  frm.Width := 300;
  frm.Height:= 80;


end;

end.

