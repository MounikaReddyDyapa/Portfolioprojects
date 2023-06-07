function handleStateChange() {
  var stateSelect = document.getElementById('state');
  var customTaxDiv = document.getElementById('customTax');
  
  if (stateSelect.value === 'custom') {
    customTaxDiv.style.display = 'block';
  } else {
    customTaxDiv.style.display = 'none';
  }
}

function calculate() {
  var propertyValue = parseFloat(document.getElementById('propertyValue').value);
  var downPaymentPercentage = parseFloat(document.getElementById('downPayment').value);
  var loanAmount = parseFloat(document.getElementById('loanAmount').value);
  var loanTerm = parseFloat(document.getElementById('loanTerm').value);
  var interestRate = parseFloat(document.getElementById('interestRate').value);
  var stateSelect = document.getElementById('state');
  var stateTaxRate = 0;

  if (stateSelect.value === 'custom') {
    stateTaxRate = parseFloat(document.getElementById('customTaxRate').value);
  } else {
    stateTaxRate = parseFloat(stateSelect.value);
  }

  // Calculate loan amount if down payment percentage is provided
  if (downPaymentPercentage) {
    loanAmount = propertyValue - (propertyValue * (downPaymentPercentage / 100));
    document.getElementById('loanAmount').value = loanAmount.toFixed(2);
  }

  // Calculate down payment percentage if loan amount is provided
  if (loanAmount) {
    downPaymentPercentage = ((propertyValue - loanAmount) / propertyValue) * 100;
    document.getElementById('downPayment').value = downPaymentPercentage.toFixed(2);
  }

  var monthlyInterestRate = interestRate / 100 / 12;
  var loanTermInMonths = loanTerm * 12;

  var monthlyPayment = (loanAmount * monthlyInterestRate) /
    (1 - Math.pow(1 + monthlyInterestRate, -loanTermInMonths));
  monthlyPayment = monthlyPayment.toFixed(2);

  var propertyTax = (propertyValue * (stateTaxRate / 100)) / 12;
  propertyTax = propertyTax.toFixed(2);

  var total = parseFloat(monthlyPayment) + parseFloat(propertyTax);
  total = total.toFixed(2);
  
  var downPaymentPercentage = parseFloat(document.getElementById('downPayment').value);
  var downPaymentAmount = (propertyValue * downPaymentPercentage) / 100;
  downPaymentAmount = downPaymentAmount.toFixed(2);

  var totalInterestPaid = (monthlyPayment * loanTermInMonths) - loanAmount;
  totalInterestPaid = totalInterestPaid.toFixed(2);


  // Display results
  document.getElementById('monthlyPayment').textContent = '$' + monthlyPayment;
  document.getElementById('propertyTaxAmount').textContent = '$' + propertyTax;
  document.getElementById('totalAmount').textContent = '$' + total;
  document.getElementById('downPaymentAmount').textContent = '$' + downPaymentAmount;
  document.getElementById('totalInterestPaid').textContent = '$' + totalInterestPaid;

  // Show the appropriate result container
  document.getElementById('result').style.display = 'block';

}

function updateLoanAmount() {
  var propertyValue = parseFloat(document.getElementById('propertyValue').value);
  var downPaymentPercentage = parseFloat(document.getElementById('downPayment').value);

  if (propertyValue && downPaymentPercentage) {
    var loanAmount = propertyValue - (propertyValue * (downPaymentPercentage / 100));
    document.getElementById('loanAmount').value = loanAmount.toFixed(2);
  }
}

function updateDownPayment() {
  var propertyValue = parseFloat(document.getElementById('propertyValue').value);
  var loanAmount = parseFloat(document.getElementById('loanAmount').value);

  if (propertyValue && loanAmount) {
    var downPaymentPercentage = ((propertyValue - loanAmount) / propertyValue) * 100;
    document.getElementById('downPayment').value = downPaymentPercentage.toFixed(2);
  }
}

function clearForm() {
  document.getElementById('propertyValue').value = '';
  document.getElementById('downPayment').value = '';
  document.getElementById('loanAmount').value = '';
  document.getElementById('interestRate').value = '';
  document.getElementById('loanTerm').value = '';
  document.getElementById('state').value = '';
  document.getElementById('customTaxRate').value = '';

  document.getElementById('result').style.display = 'none';
}

// Event listeners
document.getElementById('propertyValue').addEventListener('input', updateLoanAmount);
document.getElementById('downPayment').addEventListener('input', updateLoanAmount);
document.getElementById('loanAmount').addEventListener('input', updateDownPayment);
document.getElementById('clearButton').addEventListener('click', clearForm);
