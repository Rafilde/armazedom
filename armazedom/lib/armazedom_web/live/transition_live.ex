defmodule ArmazedomWeb.TransitionLive do
  use ArmazedomWeb, :live_view
  alias Armazedom.Repo

  def render(assigns) do
    ~H"""
    <div class="p-6 max-w-3xl mx-auto bg-white rounded-lg shadow-lg">
      <div class="bg-gradient-to-r from-blue-500 to-blue-700 rounded-t-lg px-6 py-4 text-white">
        <h1 class="text-2xl font-semibold">Adicionar Receita ou Despesa</h1>
      </div>

      <form phx-submit="salvar" class="space-y-6 mt-4">
        <div>
          <label for="tipo" class="block text-sm font-medium text-zinc-900">Tipo</label>
          <select name="type" id="type" value={@type}
            class="block w-full rounded-md border border-zinc-300 bg-white px-4 py-2 text-sm text-zinc-700 shadow-sm focus:outline-none focus:border-blue-600 focus:ring-1 focus:ring-blue-600 transition ease-in-out duration-150">
            <option value="receita">Receita</option>
            <option value="despesa">Despesa</option>
          </select>
        </div>

        <div>
          <label for="descricao" class="block text-sm font-medium text-zinc-900">Descrição</label>
          <input type="text" id="descricao" name="description" value={@description}
            class="block w-full rounded-md border border-zinc-300 bg-white px-4 py-2 text-sm text-zinc-700 shadow-sm focus:outline-none focus:border-blue-600 focus:ring-1 focus:ring-blue-600 transition ease-in-out duration-150" required />
        </div>

        <div>
          <label for="periodo" class="block text-sm font-medium text-zinc-900">Período</label>
          <select name="period" id="periodo" value={@period}
            class="block w-full rounded-md border border-zinc-300 bg-white px-4 py-2 text-sm text-zinc-700 shadow-sm focus:outline-none focus:border-blue-600 focus:ring-1 focus:ring-blue-600 transition ease-in-out duration-150" required>
            <option value="15">Quinzenal</option>
            <option value="30">Mensal</option>
            <option value="90">Trimestral</option>
            <option value="180">Semestral</option>
            <option value="365">Anual</option>
          </select>
        </div>

        <div>
          <label for="valor" class="block text-sm font-medium text-zinc-900">Valor</label>
          <input type="number" step="0.01" id="valor" name="amount" value={@amount}
            class="block w-full rounded-md border border-zinc-300 bg-white px-4 py-2 text-sm text-zinc-700 shadow-sm focus:outline-none focus:border-blue-600 focus:ring-1 focus:ring-blue-600 transition ease-in-out duration-150" required />
        </div>

        <div class="flex justify-end mt-6 space-x-4">
          <button type="button" phx-click="cancelar" class="rounded-md bg-gray-400 px-6 py-2 text-sm font-semibold text-white shadow-md hover:bg-gray-500 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-gray-500 transition duration-200">
            Cancelar
          </button>
          <button type="submit" class="rounded-md bg-blue-600 px-6 py-2 text-sm font-semibold text-white shadow-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-600 transition duration-200">
            Salvar
          </button>
        </div>
      </form>
    </div>
    """
  end


  def mount(%{"user_id" => user_id}, _session, socket) do
    # Tenta converter o user_id para inteiro, se possível
    case Integer.parse(user_id) do
      {user_id_int, _rest} ->
        # Se a conversão for bem-sucedida, usamos o valor convertido
        IO.inspect(user_id_int, label: "user_id")

        # Atribuindo valores ao socket
        {:ok, assign(socket, type: "receita", description: "", amount: "", period: 30, user_id: user_id_int)}

      :error ->
        # Se a conversão falhar, podemos lidar com o erro
        IO.inspect("Erro ao converter user_id para inteiro", label: "Erro")
        {:noreply, socket}  # Ou pode enviar um erro ou uma ação específica
    end
  end


  def handle_event("salvar", %{"type" => type, "description" => description, "amount" => amount, "period" => period}, socket) do
    # Criando a estrutura da transação com os dados do formulário
    changeset = Armazedom.Financials.Transaction.changeset(%Armazedom.Financials.Transaction{}, %{
      type: type,
      description: description,
      amount: Decimal.new(amount),
      period: String.to_integer(period),
      user_id: socket.assigns.user_id
    })

    # Salvar a transação no banco de dados
    case Repo.insert(changeset) do
      {:ok, _transaction} ->
        {:noreply, push_navigate(socket, to: "/")}

      {:error, changeset} ->
        IO.inspect(changeset)
        {:noreply, assign(socket, error: "Erro ao salvar a transação")}
    end
  end



  def handle_event("atualizar_descricao", %{"descricao" => descricao}, socket) do
    {:noreply, assign(socket, descricao: descricao)}
  end

  def handle_event("atualizar_valor", %{"valor" => valor}, socket) do
    {:noreply, assign(socket, valor: valor)}
  end

  def handle_event("cancelar", _params, socket) do
    {:noreply, push_navigate(socket, to: "/")}
  end
end
