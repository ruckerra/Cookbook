<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="UploadRecipe.aspx.cs" Inherits="Cookbook.WebForm1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Upload a Recipe</h2>
    <asp:Panel ID="pnlUploadRecipe" runat="server">
        <div class="row">
            <div class="col-md-2">
                <label for="txtRecipeName" style="display:inline">Recipe Name: </label>
            </div>
            <div class="col-md-10">
                <asp:TextBox ID="txtRecipeName" class="form-control npt" style="display:inline" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvRecipeName" runat="server" ErrorMessage="Required" ControlToValidate="txtRecipeName" ForeColor="Red" ValidationGroup="UploadRecipe"></asp:RequiredFieldValidator>
                <asp:Label ID="lblInvalid" runat="server" Text=" This recipe name is already taken." ForeColor="Red" Visible="false"></asp:Label>
            </div>
        </div>
        <div class="row">
            <div class="col-md-2">
                <label for="txtPrepTime">Prep Time(min): </label>
            </div>
            <div class="col-md-10">
                <asp:TextBox ID="txtPrepTime" CssClass="form-control npt" style="display:inline" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvPrepTime" runat="server" ErrorMessage="Required" ControlToValidate="txtPrepTime" ForeColor="Red" ValidationGroup="UploadRecipe"></asp:RequiredFieldValidator>
                <asp:RangeValidator ID="rvPrepTime" runat="server" ControlToValidate="txtPrepTime" MinimumValue="0" MaximumValue="999" ValidationGroup="UploadRecipe" ErrorMessage=" Values must be an integer between 0 and 999." ForeColor="Red" Type="Integer"></asp:RangeValidator>
            </div>
        </div>
        <div class="row">
            <div class="col-md-2">
                <label for="txtTotalTime">Total Time(min): </label>
            </div>
            <div class="col-md-10">
                <asp:TextBox ID="txtTotalTime" CssClass="form-control npt" style="display:inline" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvTotalTime" runat="server" ErrorMessage="Required" ControlToValidate="txtTotalTime" ForeColor="Red" ValidationGroup="UploadRecipe"></asp:RequiredFieldValidator>
                <asp:RangeValidator ID="rvTotalTime" runat="server" ControlToValidate="txtTotalTime" MinimumValue="0" MaximumValue="999" ValidationGroup="UploadRecipe" ErrorMessage=" Values must be an integer between 0 and 999." ForeColor="Red" Type="Integer"></asp:RangeValidator>
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
                <asp:TextBox ID="txtIngredients" CssClass="form-control npt" style="display:inline" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvIngredients" runat="server" ErrorMessage="Required" ControlToValidate="txtIngredients" ForeColor="Red" ValidationGroup="UploadRecipe"></asp:RequiredFieldValidator>
            </div>
        </div>
        <div class="row">
            <div class="col-md-2">
                <label for="txtDirections">Directions: </label>
            </div>
            <div class="col-md-10">
                <asp:TextBox ID="txtDirections" CssClass="form-control npt" style="display:inline" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvDirections" runat="server" ErrorMessage="Required" ControlToValidate="txtDirections" ForeColor="Red" ValidationGroup="UploadRecipe"></asp:RequiredFieldValidator>
            </div>
        </div>
        <div class="row">
            <div class="col-md-2">
                <label for="txtNotes">Notes: </label>
            </div>
            <div class="col-md-10">
                <asp:TextBox ID="txtNotes" CssClass="form-control npt" runat="server"></asp:TextBox>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <b><asp:Label for="fuRecipeImage" ID="recipeImg" runat="server" Text="Recipe Image: (This will be viewable when viewing the recipe.)" Visible ="false" style="display:block"></asp:Label></b>
                <asp:FileUpload ID="fuRecipeImage" style="margin-bottom:1rem" runat="server" ClientIDMode="Static" CssClass="form-control-file" Visible="false"/>
            </div>
        </div>
        <div class="row">
            <div class ="col-md-6">
                <asp:Button ID="btnSave" runat="server" Text="Upload" OnClick="btnSave_Click" CssClass="btn btn-primary btn-frost btn-oline-primary" ValidationGroup="UploadRecipe" />
                <asp:Button ID="btnUpdate" runat="server" Text="Update" Visible="False" CssClass="btn btn-primary btn-frost btn-oline-primary" OnClick="btnUpdate_Click" />
                <asp:Button ID="btnCancel" runat="server" Text="Cancel" Visible="False" CssClass="btn btn-secondary btn-frost btn-oline-secondary" OnClick="btnCancel_Click"/>
                <asp:Label ID="lblFeedback" runat="server" Text="" Visible ="False"></asp:Label>
                <asp:Label ID="lblRecipeId" runat="server" Text="Label" Visible ="false"></asp:Label>
                <div>
                    <asp:Label ID="lblHeader" runat="server" Text="" style="display:block"></asp:Label>
                </div>
            </div>
        </div>

    </asp:Panel>
    <asp:Panel ID="pnlAddNutrition" runat="server" Visible="false">
        <h2>Nutrition Information</h2>
        <div class="row">
            <div class="col-md-2">
                <label for="txtCalories">Calories: </label>
            </div>
            <div class="col-md-6">
                <asp:TextBox ID="txtCalories" CssClass="form-control npt" style="display:inline" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvCalories" runat="server" ErrorMessage="Required" ControlToValidate="txtCalories" ForeColor="Red" ValidationGroup="Nutrition"></asp:RequiredFieldValidator>
                <asp:RangeValidator ID="rvCalories"  runat="server" ErrorMessage="Value must be an integer" ControlToValidate="txtCalories" ForeColor="Red" MaximumValue="5000" MinimumValue="0" Type="Integer" ValidationGroup="Nutrition"></asp:RangeValidator>
            </div>
        </div>
        <div class="row">
            <div class="col-md-2">
                <label for="txtFat">Fat: </label>
            </div>
            <div class="col-md-6">
                <asp:TextBox ID="txtFat" CssClass="form-control npt" style="display:block" runat="server"></asp:TextBox>
                <asp:RangeValidator ID="rvFat" runat="server" ControlToValidate="txtFat" ErrorMessage="Value must be an integer" ForeColor="Red" MaximumValue="5000" MinimumValue="0" ValidationGroup="Nutrition" Type="Integer"></asp:RangeValidator>
            </div>
        </div>
        <div class="row">
            <div class="col-md-2">
                <label for="txtCarbs">Carbs: </label>
            </div>
            <div class="col-md-6">
                <asp:TextBox ID="txtCarbs" CssClass="form-control npt" style="display:block" runat="server"></asp:TextBox>
                <asp:RangeValidator ID="rvCarbs" runat="server" ErrorMessage="Value must be an integer" ValidationGroup="Nutrition" ControlToValidate="txtCarbs" MaximumValue="5000" MinimumValue="0" ForeColor="Red" Type="Integer"></asp:RangeValidator>
            </div>
        </div>
        <div class="row">
            <div class="col-md-2">
                <label for="txtFiber">Fiber: </label>
            </div>
            <div class="col-md-6">
                <asp:TextBox ID="txtFiber" CssClass="form-control npt" style="display:block" runat="server"></asp:TextBox>
                <asp:RangeValidator ID="rvFiber" runat="server" ErrorMessage="Value must be an integer" ControlToValidate="txtFiber" ForeColor="Red" MaximumValue="5000" MinimumValue="0" Type="Integer" ValidationGroup="Nutrition"></asp:RangeValidator>
            </div>
        </div>
        <div class="row">
            <div class="col-md-2">
                <label for="txtProtein">Protein: </label>
            </div>
            <div class="col-md-6">
                <asp:TextBox ID="txtProtein" CssClass="form-control npt" style="display:block" runat="server"></asp:TextBox>
                <asp:RangeValidator ID="rvProtein" runat="server" ErrorMessage="Value must be an integer" ControlToValidate="txtProtein" ForeColor="Red" MaximumValue="5000" MinimumValue="0" Type="Integer" ValidationGroup="Nutrition"></asp:RangeValidator>
            </div>
        </div>
        <div class="row">
            <div class="col-md-2">
                <label for="txtServings">Servings: </label>
            </div>
            <div class="col-md-6">
                <asp:TextBox ID="txtServings" CssClass="form-control npt" style="display:block" runat="server"></asp:TextBox>
                <asp:RangeValidator ID="rvServings" runat="server" ErrorMessage="Value must be an integer" ControlToValidate="txtServings" ForeColor="Red" MaximumValue="1000" MinimumValue="0" Type="Integer" ValidationGroup="Nutrition"></asp:RangeValidator>
            </div>
        </div>
        <div class="row">
            <div class="col-md-2">
                <label for="txtNutritionNotes">Notes: </label>
            </div>
            <div class="col-md-6">
                <asp:TextBox ID="txtNutritionNotes" CssClass="form-control npt" style="display:block" TextMode="MultiLine" runat="server"></asp:TextBox>
            </div>
        </div>
        <div class="row">
            <asp:Button ID="btnSubmitNutrition" runat="server" ValidationGroup="Nutrition" Text="Submit Nutrition" CssClass="btn btn-primary btn-frost btn-oline-primary" OnClick="btnSubmitNutrition_Click" />
            <asp:Button ID="btnCancelNutrition" runat="server" Text="Cancel Nutrition" CssClass="btn btn-secondary btn-frost btn-oline-secondary" OnClick="btnCancelNutrition_Click" />
        </div>
    </asp:Panel>
    <asp:Panel ID="pnlDisplayRecipes" class="frost" runat="server">
        <asp:GridView ID="gvDisplayRecipes" runat="server" CssClass="table tbl" AutoGenerateColumns="False" DataKeyNames="recipe_id" OnRowCommand="gvDisplayRecipes_RowCommand" OnRowDataBound="gvDisplayRecipes_RowDataBound">

            <Columns>
                <asp:BoundField DataField="recipe_id" HeaderText="ID" />
                <asp:BoundField DataField="recipe_name" HeaderText="Name" />
                <asp:BoundField DataField="ingredients" HeaderText="Ingredients" />
                <asp:BoundField DataField="total_time" HeaderText="Estimated Time" />
                <asp:TemplateField HeaderText="Actions">
                    <ItemTemplate>
                        <asp:Button ID="btnEdit" runat="server" CssClass="btn btn-primary btn-frost btn-oline-primary" Text="Edit" CommandName="EditRecipe" />
                        <asp:Button ID="btnNutrition" runat="server" CssClass="btn btn-secondary btn-frost btn-oline-secondary" Text="Nutrition" CommandName ="Nutrition" />
                        <asp:Button ID="btnDelete" runat="server" CssClass="btn btn-danger btn-frost btn-oline-danger" Text="Delete" OnClientClick="return confirm('Are you sure you want to delete this recipe?');" CommandName="DeleteRecipe" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>

        </asp:GridView>
    </asp:Panel>

</asp:Content>