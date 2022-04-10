<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RegisterAccount.aspx.cs" Inherits="Cookbook.RegisterAccount" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:Panel ID="PnlRegister" runat="server">
        <div class="row">
            <div class="col-md-4"></div>
            <div class="col-md-4">
                <h2>Create an Account</h2>
                <asp:Label ID="usernameReject" runat="server" ForeColor="Red" Text="Requested Username Already Exists" Visible="false" style="display:block"></asp:Label>
                <asp:Label ID="emailReject" runat="server" ForeColor="Red" Text="Given Email is Already Registered" Visible="false"></asp:Label>
                <div class="input-group">
                    <asp:RequiredFieldValidator ID="rfvUsername" runat="server" ControlToValidate="TxtbxRegUsername" EnableTheming="True" ErrorMessage="Required* " ForeColor="Red" ValidationGroup="Registration"></asp:RequiredFieldValidator>
                    <asp:TextBox ID="TxtbxRegUsername" runat="server" placeholder="Username*" CssClass="form-control" style="display:inline"></asp:TextBox>
                    <br />
                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="TxtbxRegEmail" EnableTheming="True" ErrorMessage="Required* " ForeColor="Red" ValidationGroup="Registration"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="regexvEmail" runat="server" ValidationExpression=".+@.+\..+" ControlToValidate="TxtbxRegEmail" ForeColor="Red" ErrorMessage="This is not an email* " ValidationGroup="Registration"></asp:RegularExpressionValidator>
                    <asp:TextBox ID="TxtbxRegEmail" runat="server" placeholder="Email*" CssClass="form-control"></asp:TextBox>
                    <br />
                    <asp:RequiredFieldValidator ID="rfvEmailCheck" runat="server" ControlToValidate="TxtbxEmailCheck" EnableTheming="True" ErrorMessage="Required* " ForeColor="Red" ValidationGroup="Registration"></asp:RequiredFieldValidator>
                    <asp:CompareValidator ID="cmpvEmail" runat="server" ControlToCompare="TxtbxRegEmail" ControlToValidate="TxtbxEmailCheck" ForeColor="Red" ErrorMessage="Emails do not match*" ValidationGroup="Registration"></asp:CompareValidator>
                    <asp:TextBox ID="TxtbxEmailCheck" type="Email" runat="server" placeholder="Repeat Email*" CssClass="form-control"></asp:TextBox>
                    <br />
                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="TxtbxRegPassword" EnableTheming="True" ErrorMessage="Required* " ForeColor="Red" ValidationGroup="Registration"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="regexvPassword" runat="server" ControlToValidate="TxtbxRegPassword" ValidationExpression=".{8,20}" ForeColor="Red" ErrorMessage="8-20 Characters Required*" ValidationGroup="Registration"></asp:RegularExpressionValidator>
                    <asp:TextBox style="display:inline" ID="TxtbxRegPassword" runat="server" type="Password" placeholder="Password*" CssClass="form-control"></asp:TextBox>
                    <br />
                    <asp:RequiredFieldValidator ID="rfvPasswordCheck" runat="server" ControlToValidate="TxtbxPasswordCheck" EnableTheming="True" ErrorMessage="Required* " ForeColor="Red" ValidationGroup="Registration"></asp:RequiredFieldValidator>
                    <asp:CompareValidator ID="cmpvPassword" runat="server" ControlToCompare="TxtbxRegPassword" ControlToValidate="TxtbxPasswordCheck" ForeColor="Red" ErrorMessage="Passwords do not match*" ValidationGroup="Registration"></asp:CompareValidator>
                    <asp:TextBox ID="TxtbxPasswordCheck" runat="server" type="Password" placeholder="Repeat Password*" CssClass="form-control"></asp:TextBox>
                    <br />
                    <div style="display:inline-block">&nbsp</div>
                    <asp:Button ID="BtnCreateAccount" runat="server" Text="Create Account" CssClass="btn btn-primary btn-block" style="margin-bottom:1rem" OnClick="BtnCreateAccount_Click" ValidationGroup="Registration"/>
                    <a>
                        <asp:Button ID="BtnLogin" runat="server" Text="Log in Instead" CssClass="btn btn-secondary btn-block" OnClick="BtnLogin_Click" CausesValidation="False"/>
                    </a>
                </div>
            </div>
            <div class="col-md-4"></div>
        </div>

    </asp:Panel>
</asp:Content>
