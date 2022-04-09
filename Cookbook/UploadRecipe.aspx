﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="UploadRecipe.aspx.cs" Inherits="Cookbook.WebForm1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Upload a Recipe</h2>
    <asp:Panel ID="pnlUploadRecipe" runat="server">
        <div class="row">
            <div class="col-md-2">
                <label for="txtRecipeName">Recipe Name: </label>
            </div>
            <div class="col-md-10">
                <asp:TextBox ID="txtRecipeName" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvRecipeName" runat="server" ErrorMessage="Required" ControlToValidate="txtRecipeName" ForeColor="Red" ValidationGroup="UploadRecipe"></asp:RequiredFieldValidator>
            </div>
        </div>
        <div class="row">
            <div class="col-md-2">
                <label for="txtPrepTime">Prep Time: </label>
            </div>
            <div class="col-md-10">
                <asp:TextBox ID="txtPrepTime" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvPrepTime" runat="server" ErrorMessage="Required" ControlToValidate="txtPrepTime" ForeColor="Red" ValidationGroup="UploadRecipe"></asp:RequiredFieldValidator>
            </div>
        </div>
        <div class="row">
            <div class="col-md-2">
                <label for="txtTotalTime">Total Time: </label>
            </div>
            <div class="col-md-10">
                <asp:TextBox ID="txtTotalTime" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvTotalTime" runat="server" ErrorMessage="Required" ControlToValidate="txtTotalTime" ForeColor="Red" ValidationGroup="UploadRecipe"></asp:RequiredFieldValidator>
            </div>
        </div>
        <div class="row">
            <div class="col-md-2">
                <label for="chkGlutenFree">Gluten Free: </label>
            </div>
            <div class="col-md-2">
                <asp:CheckBox ID="chkGlutenFree" runat="server" Text="Yes" />
            </div>
        </div>
        <div class="row">
            <div class="col-md-2">
                <label for="chkVegetarian">Vegetarian: </label>
            </div>
            <div class="col-md-2">
                <asp:CheckBox ID="chkVegetarian" runat="server" Text="Yes" />
            </div>
        </div>
        <div class="row">
            <div class="col-md-2">
                <label for="ddType">Type: </label>
            </div>
            <div class="col-md-10">
                <asp:DropDownList ID="ddType" runat="server" CssClass="dropdown">
                    <asp:ListItem>Breakfast</asp:ListItem>
                    <asp:ListItem>Lunch</asp:ListItem>
                    <asp:ListItem>Dinner</asp:ListItem>
                    <asp:ListItem>Dessert</asp:ListItem>
                    <asp:ListItem>Snack</asp:ListItem>
                    <asp:ListItem>Appetizer</asp:ListItem>
                    <asp:ListItem>Brunch</asp:ListItem>
                    <asp:ListItem>Linner</asp:ListItem>
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="rfvType" runat="server" ErrorMessage="Required" ControlToValidate="ddType" ForeColor="Red" ValidationGroup="UploadRecipe"></asp:RequiredFieldValidator>
            </div>
        </div>
        <div class="row">
            <div class="col-md-2">
                <label for="txtIngredients">Ingredients: </label>
            </div>
            <div class="col-md-10">
                <asp:TextBox ID="txtIngredients" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvIngredients" runat="server" ErrorMessage="Required" ControlToValidate="txtIngredients" ForeColor="Red" ValidationGroup="UploadRecipe"></asp:RequiredFieldValidator>
            </div>
        </div>
        <div class="row">
            <div class="col-md-2">
                <label for="txtDirections">Directions: </label>
            </div>
            <div class="col-md-10">
                <asp:TextBox ID="txtDirections" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvDirections" runat="server" ErrorMessage="Required" ControlToValidate="txtDirections" ForeColor="Red" ValidationGroup="UploadRecipe"></asp:RequiredFieldValidator>
            </div>
        </div>
        <div class="row">
            <div class="col-md-2">
                <label for="txtNotes">Notes: </label>
            </div>
            <div class="col-md-10">
                <asp:TextBox ID="txtNotes" runat="server"></asp:TextBox>
            </div>
        </div>
        <div class="row">
            <div class ="col-md-6">
                <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" CssClass="btn btn-primary" ValidationGroup="UploadRecipe"/>
                <asp:Button ID="btnUpdate" runat="server" Text="Update" Visible="False" CssClass="btn btn-primary" />
                <asp:Button ID="btnCancel" runat="server" Text="Cancel" Visible="False" CssClass="btn btn-secondary"/>
                <asp:Label ID="lblFeedback" runat="server" Text="" Visible ="False"></asp:Label>
            </div>
        </div>

    </asp:Panel>
    <asp:Panel ID="pnlDisplayRecipes" runat="server">
        <asp:GridView ID="gvDisplayRecipes" runat="server" CssClass="table table-bordered" AutoGenerateColumns="False" DataKeyNames="recipe_id">

            <Columns>
                <asp:BoundField DataField="recipe_id" HeaderText="ID" />
                <asp:BoundField DataField="recipe_name" HeaderText="Name" />
                <asp:BoundField DataField="ingredients" HeaderText="Ingredients" />
                <asp:BoundField DataField="total_time" HeaderText="Estimated Time" />
                <asp:TemplateField HeaderText="Actions">
                    <ItemTemplate>
                        <asp:Button ID="btnEdit" runat="server" CssClass="btn btn-primary" Text="Edit" />
                        <asp:Button ID="btnDelete" runat="server" CssClass="btn btn-danger" Text="Delete" Width="61px" OnClientClick="return confirm('Are you sure you want to delete this recipe?');" CommandName="Delete" CommandArgument="recipe_id" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>

        </asp:GridView>
    </asp:Panel>

</asp:Content>