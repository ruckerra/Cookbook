<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Cookbook.Login" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <br/>
    <asp:Panel ID="PnlLogin" runat="server">
            <div class="row">
                <div class="col-md-4"></div>
                <div id="LoginInput" class="col-md-4">
                    <h2>Log In</h2>
                    <div class="input-group" style="margin-bottom:1rem">
                        <asp:RequiredFieldValidator ID="rfvUsername" runat="server" ControlToValidate="TxtbxUsername" EnableTheming="True" ErrorMessage="Required*" ForeColor="Red" ValidationGroup="Register"></asp:RequiredFieldValidator>
                        <asp:TextBox ID="TxtbxUsername" runat="server" style="margin-bottom:1rem" placeholder="Username or Email" CssClass="form-control"></asp:TextBox>
                        <br />
                        <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="TxtbxPassword" EnableTheming="True" ErrorMessage="Required*" ForeColor="Red" ValidationGroup="Register"></asp:RequiredFieldValidator>
                        <asp:TextBox ID="TxtbxPassword" runat="server" type="Password" placeholder="Password" CssClass="form-control"></asp:TextBox>
                        <br />
                        <div style="inline-block">&nbsp</div>
                        <asp:Button ID="BtnSubmit" runat="server" style="margin-bottom:1rem" Text="Log In" CssClass="btn btn-primary btn-block" class="form-control" Enabled="False"/>
                        <a>
                            <asp:Button ID="BtnRegister" runat="server" style="margin-bottom:1rem" Text="Create an Account" CssClass="btn btn-secondary btn-block" class="form-control" OnClick="BtnRegister_Click"/>
                        </a>

                    </div>
                <div class="col-md-4"></div>
            </div>
    </asp:Panel>
    <br/>

</asp:Content>
