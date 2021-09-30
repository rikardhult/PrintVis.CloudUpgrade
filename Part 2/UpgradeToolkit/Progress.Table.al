Table 99999 "PVS Upgrade Progress"
{

    fields
    {
        field(1; "Preparation Step"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Import Toolkit","Setup Integration Runtime","Install Extensions","Configure Table Mapping";
        }
        field(2; "Conversion Step"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Configured,Executed,Error,RunUpgrade,Ready;
        }
        field(3; Description; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(4; Status; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionMembers = " ",Manual,Required,Executed;
        }
    }

    keys { key(Key1; "Preparation Step", "Conversion Step") { Clustered = true; } }


    procedure ExecuteStep()
    var
        CloudUpgradeSetup: Record "PVS Cloud Upgrade Setup";
        CloudUpgradeMgt: Codeunit "PTE Cloud Upgrade Mgt.";
    begin
        case "Preparation Step" of
            "Preparation step"::"Import Toolkit":
                Message('Write some code to test stuff'); // TODO Write some code to test stuff
            "Preparation step"::"Setup Integration Runtime":
                Page.Run(4000);
            "Preparation step"::"Install Extensions":
                Message('Write some code to test this'); // TODO Write some code to test this'
            "Preparation step"::"Configure Table Mapping":
                Page.Run(4003);
        end;

        case "Conversion Step" of
            "Conversion step"::Configured:
                Message('Write some code to test this'); // TODO Write some code to test this'
            "Conversion Step"::Executed:
                Page.Run(4003);
            "Conversion step"::Error:
                Page.Run(Page::"PrintVis Cloud Upgrade Details");
            "Conversion Step"::RunUpgrade:
                RunUpgrade;
            "Conversion Step"::Ready:
                Message('Congratulations');
        end;

        Status := Status::Executed;
        Modify;
    end;

    local procedure RunUpgrade()
    var
        UpgradeLogic: Codeunit "PTE Upgrade Logic";
    begin
        UpgradeLogic.CapUnitRoundingUpDown();

        UpgradeLogic.MergePointerTables();
        UpgradeLogic.MovedCustomerTemplateIfNotExist();
        UpgradeLogic.MovedItemTemplateIfNotExist();
        UpgradeLogic.MoveCaseMgtMatrix();
        UpgradeLogic.MovePlanningBoardPermissionDo();
        ConvertCombinedShipments();
        UpgradeLogic.UpgradeGrossQuotedPricePVSJob();


    end;

    local procedure ConvertCombinedShipments()
    var
        Shpmnt: Record "PVS Job Shipment";
    begin
        Shpmnt.SetFilter("Combined Shipment No.", '%1', '');
        if Shpmnt.FindSet(true) then
            repeat
                Shpmnt.GetCombinedShipmentNo();
                Shpmnt.Modify()
            until Shpmnt.Next() = 0;
    end;

}

