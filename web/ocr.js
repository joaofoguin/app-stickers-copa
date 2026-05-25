window.reconhecerTextoImagem = async function (base64Image) {
  if (typeof Tesseract === 'undefined') {
    throw new Error('Tesseract.js não foi carregado.');
  }

  const worker = await Tesseract.createWorker('eng');

  const resultado = await worker.recognize(base64Image);

  await worker.terminate();

  return resultado.data.text;
};